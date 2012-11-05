#coding:utf-8

# buildin import
from random import random
from hashlib import md5
from datetime import datetime

# third import
import sqlalchemy as sa
from sqlalchemy.exc import IntegrityError
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import relationship, backref

#http://docs.sqlalchemy.org/en/rel_0_7/core/expression_api.html#sqlalchemy.sql.expression.text
#from sqlalchemy.sql.expression import text

#from sqlalchemy import Column, Integer, String

# local import
import config


BaseModel = declarative_base()

class ModelExtend(object):
    def update(self, **kwargs):
        for attr, value in kwargs.iteritems():
            if hasattr(self, attr):
                setattr(self,attr,value)


class User(BaseModel, ModelExtend):
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

#book_author_association = sa.Table("book_author_association", 
#        BaseModel.metadata, 
#        sa.Column('author_id', sa.Integer, 'authors.id'),
#        sa.Column('Booke_id', sa.Integer, 'Book.id')
#        )
#
#class Author(BaseModel):
#    __tablename__ = 'authors'
#    id = sa.Column(sa.Integer, primary_key=True, autoincrement=True)
#    name = sa.Column(sa.String(100), index=True, unique=False)
#    intro = sa.Column(sa.Text)
#    isTranslator = sa.Column(sa.Boolean, default=False)

class Book(BaseModel,ModelExtend):
    #目前尽量只添加和业务逻辑有关的列
    __tablename__ = 'books'
    id = sa.Column(sa.Integer, primary_key=True, autoincrement=True)
    #TODO  should title be unique?
    title = sa.Column(sa.String(100), nullable=False,\
            unique=False, index=True)
    subtitle = sa.Column(sa.String(100), index=True)
    #authors = relationship('Author',
    #        secondary=book_author_association,
    #        bacref='authors')
    authors = sa.Column(sa.String(100), index=True)
    #maintainer  
    #license
    #privilige
    summary = sa.Column(sa.Text)
    chapters = relationship('Chapter', backref='book')

class Chapter(BaseModel, ModelExtend):
    __tablename__ = 'chapters'
    id = sa.Column(sa.Integer, primary_key=True, autoincrement=True)
    title = sa.Column(sa.String(100))
    book_id = sa.Column(sa.Integer, sa.ForeignKey('books.id'))
    content = sa.Column(sa.Text)

    def __cmp__(self, other):
        return self.id - other.id



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
        force = raw_input('input `yes` to drop conflict table:')
        if force.lower() == 'yes':
            initDb(force=True)
        else:
            print(u'bye')
    else:
        initDb()
