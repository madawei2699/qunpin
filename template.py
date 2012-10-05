# coding: utf-8

from jinja2 import Environment, FileSystemLoader

import config

class Render:
    '''此类提供对jinja2模板的支持, 以及自定义过滤器的功能.

    :注意:

         - jinja2要求模板中字符串值必须为unicode的, 所以请确保你的模板中
         - 的字符串为unicode的, 即在render的最后一个字典参数中的所有value
         - 必须为u'群品'这样的字符串, 而不是'群品'
    '''
    def __init__(self, *a, **kwargs):
        extensions = kwargs.pop('extensions', [])
        globals = kwargs.pop('globals', {})

        self.env = Environment(
            loader=FileSystemLoader(*a, **kwargs),
            extensions=extensions,
            trim_blocks=True,
        )
        self.env.globals.update(globals)

    def render(self, handler, path, **kwargs):
        '''利用jinja2渲染模板, 并结合tornado的write方法显示页面

        :参数:

            :handler: 网址调用类
            :path: 模板路径(如果带后缀, 则必须为.html后缀)
            :kwargs: 传递到模板中的参数字典
        '''
        # 将tornado中的传递给模板的隐式参数'转移'到jinja2中
        args = dict(
            handler = handler,
            request = handler.request,
            current_user = handler.current_user,
            locale = handler.locale,
            _ = handler.locale.translate,
            static_url = handler.static_url,
            xsrf_form_html = handler.xsrf_form_html,
            reverse_url = handler.application.reverse_url
        )
        args.update(handler.ui)
        kwargs.update(args)

        handler.write(self.env.get_template('%s.html' % path.strip('.html')).render(**kwargs))

    def add_filter(self, filter_func, filter_name=None):
        '''添加自定义的filter(过滤器)

        :参数:

            :filter_func: 定义过滤器的函数
            :filter_name: 此过滤器在模板中的名称, 如果为None,将使用filter_func的函数名

        :使用方法:

            # filters.py
            def test_add(value, second_nnum):
                return value + second_nnum
            render.add_filter(test_add, "add")

            # test_filter.html
            {{ 5|add(6) }}
            {# 将返回11 #}
        '''
        if filter_name is None:
            filter_name = filter_func.__name__
        self.env.filter[filter_name] = filter_func


