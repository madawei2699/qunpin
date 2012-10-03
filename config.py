#coding:utf-8

import os

from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker, scoped_session

# 是否开启调试模式, 生产环境中, 请设为False
DEBUG = True



# sqlalchemy 设置
# dialect+driver://username:password@host:port/database?charset=encoding
engine = create_engine(
    "mysql+mysqldb://root:root1234@localhost:3306/qp_db?charset=utf8",
    encoding='utf8',
    echo=False,  # 是否在控制台输出SQL语句
)
db = scoped_session(sessionmaker(bind=engine))



# jinja2模板设置



# 静态文件设置
app_root = os.path.dirname(__file__)
static_path = os.path.join(app_root, "static")
template_path = os.path.join(app_root, "templates")
