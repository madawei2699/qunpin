#!/usr/bin/env python
#coding:utf-8

import tornado.database
import tornado.httpserver
import tornado.ioloop
import tornado.web
import tornado.options
from tornado.options import define, options

import form as f
import models as m
import config  # 数据库配置 以及其他配置

db = config.db
define("port", default=8888, help="run on the given port", type=int)


class BaseHandler(tornado.web.RequestHandler):
    """
    handler 的基类，方便为个handler增加通用方法
    """
    def get_current_user(self):
        user_id = self.get_secure_cookie("user")
        if not user_id:
            return None
        return db.query(m.User).filter_by(id=user_id)

    def get_form(self, form_define, instance=None):
        """
        如果没有instance这个参数
        则通过get_argument 方法
        从handler.request.argument 获取

        如果有instance则从instance获取
        instance是一个模型实例

        如果想获取一个空form 直接生成一个
        FormContainer实例
        """
        form = f.FormContainer()
        if instance is not None:
            get=lambda field : getattr(instance, field, '')
        else:
            get=lambda field : self.get_argument(field, '')

        for field in form_define.keys():
            if field == '_form':
                continue
            form[field] = get(field)
        return form


    def validate(self, form, form_define):
        form_error_message = f.FormContainer()
        error = False
        for field, validator in form_define.iteritems():
            if error: #fail fast 
                break
            if field == '_form':
                continue
            form_error_message[field] = validator(form[field])
            error = error or bool(form_error_message[field])

        if not error and '_form' in form_define:
            form_error_message['form'] = form_define['_form'](form)
            error = error or bool(form_error_message['form'])
        return error, form_error_message

    def jinja_render(self, path, **kwargs):
        config.render.render(self, path, **kwargs)


class HomeHandler(BaseHandler):
    def get(self):
        users = db.query(m.User).all()
        self.jinja_render('dev_home.html', users=users)
        #self.render('dev_home.html',users=users)


class LoginHandler(BaseHandler):
    def get(self):
        self.clear_cookie('user')
        form = self.get_form(f.login_form)
        args = {'form': form,
                'form_error_message': {},
                }
        self.jinja_render('dev_login.html', **args)
        #self.render('dev_login.html',**args)

    def post(self):
        form = self.get_form(f.login_form)
        error, form_error_message = self.validate(form, f.login_form)
        if not error:
            user = db.query(m.User).filter_by(email=form['email']).one()
            self.set_secure_cookie("user", str(user.id))
            self.redirect(self.get_argument("next", "/"))
            return None
        args = {'form': form,
                'form_error_message': form_error_message,
                }
        self.jinja_render('dev_login.html', **args)
        #self.render('dev_login.html',**args)


class LogoutHandler(BaseHandler):
    def get(self):
        self.clear_cookie("user")
        self.redirect(self.get_argument("next", "/"))


class RegisterHandler(BaseHandler):
    def get(self):
        form = self.get_form(f.register_form)
        form_error_message = m.FormContainer()
        args = {'form': form,
                'form_error_message': form_error_message,
                }
        self.jinja_render('dev_register.html', **args)
        #self.render('dev_register.html',**args)

    def post(self):
        form = self.get_form(f.register_form)
        error, form_error_message = self.validate(form, f.register_form)
        if not error:
            form['password'] = form['password_1']
            del form['password_1']
            del form['password_2']
            new_user = m.User(**form)
            new_user.set_password(form['password'])
            db.add(new_user)
            db.commit()
            self.redirect(self.get_argument('next', '/login'))
            return None
        args = {'form': form,
                'form_error_message': form_error_message,
                }
        self.jinja_render('dev_register.html', **args)
        #self.render('dev_register.html',**args)


class UserConsoleHandler(BaseHandler):
    @tornado.web.authenticated
    def get(self):
        self.write('hi')


class Application(tornado.web.Application):
    def __init__(self):
        urls = [(url, globals()[handler]) for (url, handler) in config.urls]
        tornado.web.Application.__init__(self, urls, **config.settings)


def main():
    if config.DEBUG:
        m.initDb()
    tornado.options.parse_command_line()
    application = Application()
    application.listen(options.port)
    tornado.ioloop.IOLoop.instance().start()


if __name__ == "__main__":
    print "Starting server..."
    print ' * Running on http://localhost:8888'
    main()
