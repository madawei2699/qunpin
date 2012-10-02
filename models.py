#coding:utf-8
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy import Column, Integer, String


BaseModel = declarative_base()



class User(BaseModel):
    __tablename__ = 'test_user'

    uid = Column(Integer, primary_key=True, autoincrement=True)
    name = Column(String(100),nullable=False)


