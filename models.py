#coding:utf-8

from sqlalchemy.exc import IntegrityError
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy import Column, Integer, String
from sqlalchemy.orm import sessionmaker

import config

BaseModel = declarative_base()



class User(BaseModel):
    __tablename__ = 'test_user'

    uid = Column(Integer, primary_key=True, autoincrement=True)
    name = Column(String(100), nullable=False)



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
