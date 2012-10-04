#coding:utf-8

import sqlalchemy as sa
from sqlalchemy.exc import IntegrityError
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker


#http://docs.sqlalchemy.org/en/rel_0_7/core/expression_api.html#sqlalchemy.sql.expression.text
from sqlalchemy.sql.expression import text

#from sqlalchemy import Column, Integer, String

import config
from random import random
from md5 import md5
from datetime import datetime


BaseModel = declarative_base()



class User(BaseModel):
    __tablename__ = 'users'

    id = sa.Column(sa.Integer, primary_key=True, autoincrement=True)
    username = sa.Column(sa.String(100), nullable=False, index=True)
    email = sa.Column(sa.String(100), nullable=False, unique=True, index=True)
    sex = sa.Column(sa.SmallInteger, default=3)# 1:male,2:female,3:unset
    register_time = sa.Column(sa.DateTime, default=datetime.now)
    lock = sa.Column(sa.Boolean, default=False)
    password = sa.Column(sa.String(32))
    salt = sa.Column(sa.String(32))

    def _set_salt(self):
        self.salt = md5(str(random())).hexdigest()

    def set_password(self,raw_password):
        self._set_salt()
        self.password = md5(raw_password+self.salt).hexdigest()

    def auth(self,raw_password):
        password = md5(raw_password+self.salt).hexdigest()
        return password==self.password








# 初始化数据库
def initDb():
    metadata = BaseModel.metadata
    metadata.create_all(config.engine)
    #session = sessionmaker(bind=config.engine)()
    try:
        config.db.commit()
    except IntegrityError:  # 已经初始化过了
        pass

if __name__ == '__main__':
    initDb()
