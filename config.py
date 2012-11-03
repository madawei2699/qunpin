#coding:utf-8

import os

from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker, scoped_session

import template


# url config
urls = [
    (r"/", "HomeHandler"),
    (r"/login", "LoginHandler"),
    (r"/logout", "LogoutHandler"),
    (r"/register", "RegisterHandler"),
    (r"/account", "UserConsoleHandler"),
    (r"/book/edit", "BookEditorHandler"),
    (r"/book/(\d)", "BookIndexHandler"),
    (r"/book/edit_chapter/(\d)", "ChapterEditHandler"),
    (r"/book/(\d)/(\d)", "ChapterReadHandler"),
]

# 是否开启调试模式, 生产环境中, 请设为False
DEBUG = True


# sqlalchemy 设置
# dialect+driver://username:password@host:port/database?charset=encoding
engine = create_engine(
    "mysql+mysqldb://root:qunpin1234@localhost:3306/qp_db?charset=utf8",
    encoding='utf8',
    #echo=True,  # 是否在控制台输出SQL语句
    echo=False,  # 是否在控制台输出SQL语句
)
db = scoped_session(sessionmaker(bind=engine))


# 静态文件设置
app_root = os.path.dirname(__file__)
static_path = os.path.join(app_root, "static")
template_path = os.path.join(app_root, "templates")


# jinja2模板设置
render = template.Render(
    template_path,
    encoding='utf-8',
)


# tornado设置
settings = dict(
    template_path=template_path,
    static_path=static_path,
    debug=DEBUG,
    xsrf_cookies=True,
    cookie_secret="dev",
    autoescape=None,
    login_url="/login",
)
