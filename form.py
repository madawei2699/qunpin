#coding:utf-8
"""
定义每个 form 所需要的字段，以及验证函数
验证函数将返回错误信息或者空字符串

每个 form 可以有 `_form` 字段，
这个字段对应的函数将进行跨字段校验
"""
import re
import config
import models as m

db = config.db

EMAIL_PATTERN=re.compile(r'^([0-9a-zA-Z]([-.\w]*[0-9a-zA-Z])*@([0-9a-zA-Z][-\w]*[0-9a-zA-Z]\.)+[a-zA-Z]{2,9})$')


def register_form_check_username(username):
    if len(username)<1:
        return u"用户名不能为空"
    elif db.query(m.User).filter_by(username=username).first():
        return u"用户名已被注册"
    return ''

def register_form_check_email(email):
    if not EMAIL_PATTERN.match(email):
        return u"邮箱格式不正确"
    elif db.query(m.User).filter_by(email=email).first():
        return u"邮箱已被注册"
    return ''

def register_form_check_password(password):
    return '' if len(password)>1  else u"密码不能为空"

def register_form_check_form(form):
    if form['password_1']!=form['password_2']:
        return u'两次密码输入不一致'
    return ''

register_form={
        'username':register_form_check_username,
        'email':register_form_check_email,
        'password_1':register_form_check_password,
        'password_2':register_form_check_password,
        '_form':register_form_check_form,
        }
#############################

def login_form_check_email(email):
    if not EMAIL_PATTERN.match(email):
        return u"邮箱格式不正确"
    return ''


login_form_check_password = register_form_check_password

def login_form_check_form(form):
    email = form['email']
    password = form['password']
    user = db.query(m.User).filter_by(email=email).first()
    if not user or not user.auth(password):
        return u"登录验证失败"
    return ''

login_form={
        'email':login_form_check_email,
        'password':login_form_check_password,
        '_form':login_form_check_form,
        }
