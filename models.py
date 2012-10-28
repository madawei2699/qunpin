#coding:utf-8

# buildin import
from random import random
from md5 import md5
from datetime import datetime

# third import
import sqlalchemy as sa
from sqlalchemy.exc import IntegrityError
from sqlalchemy.ext.declarative import declarative_base
#from sqlalchemy.orm import sessionmaker

#http://docs.sqlalchemy.org/en/rel_0_7/core/expression_api.html#sqlalchemy.sql.expression.text
#from sqlalchemy.sql.expression import text

#from sqlalchemy import Column, Integer, String

# local import
import config


BaseModel = declarative_base()


class User(BaseModel):
    __tablename__ = 'users'

    id = sa.Column(sa.Integer, primary_key=True, autoincrement=True)
    username = sa.Column(sa.String(100), nullable=False, index=True)
    email = sa.Column(sa.String(100), nullable=False, unique=True, index=True)
    sex = sa.Column(sa.SmallInteger, default=3)  # 1:male,2:female,3:unset
    register_time = sa.Column(sa.DateTime, default=datetime.now)
    lock = sa.Column(sa.Boolean, default=False)
    password = sa.Column(sa.String(32))
    salt = sa.Column(sa.String(32))

    def _set_salt(self):
        self.salt = md5(str(random())).hexdigest()

    def set_password(self, raw_password):
        self._set_salt()
        self.password = md5(raw_password + self.salt).hexdigest()

    def auth(self, raw_password):
        password = md5(raw_password + self.salt).hexdigest()
        return password == self.password


# 初始化数据库
def initDb(force=False):
    metadata = BaseModel.metadata
    if force:
        metadata.drop_all(config.engine)
    metadata.create_all(config.engine)
    try:
        config.db.commit()
    except IntegrityError:  # 已经初始化过了
        pass

if __name__ == '__main__':
    """
    如果运行这个脚本，数据库将可能被初始化
    """
    if config.DEBUG:
        force = raw_input(u'输入`yes` 将删除旧表')
        if force.lower() == 'yes':
            initDb(force=True)
        else:
            print(u'什么都没做')
    else:
        initDb()
