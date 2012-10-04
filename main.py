#!/usr/bin/env python
#coding:utf-8

import os.path

import tornado.database
import tornado.httpserver
import tornado.ioloop
import tornado.web
import tornado.options
from tornado.options import define,options

import models as  m
import config # 数据库配置 以及其他配置

define("port", default=8888, help="run on the given port", type=int)

db = config.db
render = config.render




class Application(tornado.web.Application):
    def __init__(self):
        handlers = [
            (r"/", HomeHandler),
        ]
        settings = dict(
            template_path=config.template_path,
            static_path=config.static_path,
            debug=config.DEBUG,
            xsrf_cookies=True,
            cookie_secret="dev",
            autoescape=None,
        #    login_url="/admin/login",
        )
        tornado.web.Application.__init__(self, handlers, **settings)



class HomeHandler(tornado.web.RequestHandler):
    def get(self):
        users = db.query(m.User).all()
        self.write(render.dev_home(users=users))

    def post(self):
        name = self.get_argument('name',None)
        if name:
            new_user = m.User(name=name)
            db.add(new_user)
            db.commit()

        self.redirect('/')



def main():
    if config.DEBUG:
        m.initDb()
    tornado.options.parse_command_line()
    application = Application()
    application.listen(options.port)
    tornado.ioloop.IOLoop.instance().start()


if __name__ == "__main__":
    main()
