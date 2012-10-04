#!/usr/bin/env python
#coding:utf-8

import os.path

import tornado.database
import tornado.httpserver
import tornado.ioloop
import tornado.web
import tornado.options
from tornado.options import define,options

import form as f
import models as  m
import config # 数据库配置 以及其他配置

define("port", default=8888, help="run on the given port", type=int)

db = config.db
#render = config.render


class Application(tornado.web.Application):
    def __init__(self):
        handlers = [
            (r"/", HomeHandler),
            (r"/login", LoginHandler),
            (r"/logout", LogoutHandler),
            (r"/register", RegisterHandler),
            (r"/account", UserConsoleHandler),
        ]
        settings = dict(
            template_path=config.template_path,
            static_path=config.static_path,
            debug=config.DEBUG,
            xsrf_cookies=True,
            cookie_secret="dev",
            autoescape=None,
            login_url="/login",
        )
        tornado.web.Application.__init__(self, handlers, **settings)

class BaseHandler(tornado.web.RequestHandler):
    """
    handler 的基类，方便为个handler增加通用方法
    """
    def get_current_user(self):
        user_id = self.get_secure_cookie("user")
        if not user_id: 
            return None
        return db.query(m.User).filter_by(id=user_id)

    def get_form(self,form_define):
        form = {}
        for fild in form_define.keys():
            print('get fild ->',fild)
            if fild=='_form': continue
            form[fild] = self.get_argument(fild,'')
        return form

    def validate(self,form,form_define):
        form_error_message = {}
        error = False
        for fild,validator in form_define.iteritems():
            print('validate fild ->',fild)
            if fild=='_form':continue
            form_error_message[fild] = validator(form[fild])
            error = error or  bool(form_error_message[fild])

        if form_define.has_key('_form'):
            form_error_message['form'] = form_define['_form'](form)
            error = error or bool(form_error_message['form'])
        return error,form_error_message
            



class HomeHandler(BaseHandler):
    def get(self):
        users = db.query(m.User).all()
        #self.write(render.dev_home(users=users))
        self.render('dev_home.html',users=users)

class LoginHandler(BaseHandler):
    def get(self):
        self.clear_cookie('user')
        form = self.get_form(f.login_form)
        args = {'form':form,
                'form_error_message':{},
                }
        self.render('dev_login.html',**args)
            
    
    def post(self):
        form = self.get_form(f.login_form)
        error,form_error_message = self.validate(form,f.login_form)
        if not error:
            user = db.query(m.User).filter_by(email=form['email']).one()
            self.set_secure_cookie("user", str(user.id))
            self.redirect(self.get_argument("next", "/"))
            return None
        args = {'form':form,
                'form_error_message':form_error_message,
                }
        self.render('dev_login.html',**args)
            

        

class LogoutHandler(BaseHandler):
    def get(self):
        self.clear_cookie("user")
        self.redirect(self.get_argument("next", "/"))

class RegisterHandler(BaseHandler):
    def get(self):
        form = self.get_form(f.register_form)
        form_error_message = {}
        args = {'form':form,
                'form_error_message':form_error_message,
                }
        self.render('dev_register.html',**args)
    def post(self):
        form = self.get_form(f.register_form)
        error,form_error_message = self.validate(form,f.register_form)
        if not error:
            form['password'] = form['password_1']
            del form['password_1']
            del form['password_2']
            new_user = m.User(**form)
            new_user.set_password(form['password'])
            db.add(new_user)
            db.commit()
            self.redirect(self.get_argument('next','/login'))
            return None
        args = {'form':form,
                'form_error_message':form_error_message,
                }
        self.render('dev_register.html',**args)

class UserConsoleHandler(BaseHandler):
    @tornado.web.authenticated
    def get(self):
        self.write('hi')

def main():
    if config.DEBUG:
        m.initDb()
    tornado.options.parse_command_line()
    application = Application()
    application.listen(options.port)
    tornado.ioloop.IOLoop.instance().start()


if __name__ == "__main__":
    main()
