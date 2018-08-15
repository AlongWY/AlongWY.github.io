---
title: django里使用全文搜索框架drf_haystack
tags:
  - null
mathjax: false
date: 2018-08-15 21:02:56
categories:
---

drf_haystack
============

Small library aiming to simplify using Haystack with Django REST Framework。

<!-- more -->

准备工作
========

安装虚拟环境
------------

我这里使用的是 **virtualenv** 和 **virtualenvwrapper**。

```bash
pip install virtualenv                       # 安装环境
pip install virtualenvwrapper
source /usr/local/bin/virtualenvwrapper.sh   # 加载环境
```

对于virtualenvwrapper的配置：

```bash
if [ `id -u` != '0' ]; then
  export VIRTUALENV_USE_DISTRIBUTE=1            # <-- Always use pip/distribute
  export WORKON_HOME=$HOME/.virtualenvs         # <-- virtualenvs 的保存位置
  source /usr/local/bin/virtualenvwrapper.sh
  export PIP_VIRTUALENV_BASE=$WORKON_HOME
  export PIP_RESPECT_VIRTUALENV=true
fi
```

将上面的配置添加到 ~/.bashrc 的末尾或者~/.zshrc

### 常用命令

+ mkvirtualenv
    ```bash
    usage:

    mkvirtualenv    [-a project_path]
                    [-i package]
                    [-r requirements_file]
                    [virtualenv options] env_name
    ```
+ workon
    ```bash
    workon env_name
        Deactivate any currently activated virtualenv
        and activate the named environment, triggering
        any hooks in the process.

    workon == lsvirtualenv
        Print a list of available environments.
        (See also lsvirtualenv -b)

    workon (-h|--help)
        Show this help message.

    workon (-c|--cd) envname
        After activating the environment, cd to the associated
        project directory if it is set.

    workon (-n|--no-cd) envname
        After activating the environment, do not cd to the
        associated project directory.
    ```
+ lsvirtualenv  相当于不带参数的workon
+ deactivate    退出当前虚拟环境
+ rmvirtualenv  删除虚拟环境

以上为常用的命令足够用，具体参数其实跟virtualenv差不多。

安装需要的包
------------

```bash
mkvirtualenv dev
workon dev

pip install whoosh
pip install jieba               # 之后中文分词需要
pip install django-haystack
pip install drf_haystack
```

项目配置
========

```python
# 在INSTALL_APPS里加上 haystack (加在最后)
INSTALLED_APPS = [
    ...
    'rest_framework',
    'haystack',
    ...
]
# 增加搜索引擎配置（有solr，whoosh，elastic search）,这里选择whoosh
HAYSTACK_CONNECTIONS = {
    'default': {
        'ENGINE': 'haystack.backends.whoosh_backend.WhooshEngine',
        'PATH': os.path.join(os.path.dirname(__file__), 'whoosh_index'),
    },
}
# 配置自动更新索引
HAYSTACK_SIGNAL_PROCESSOR = 'haystack.signals.RealtimeSignalProcessor'
# 配置搜索结果的分页器的每页数量
HAYSTACK_SEARCH_RESULTS_PER_PAGE = 10
```

配置drf_haystack
----------------

```text
# templagtes/search/indexes/myapp/note_text.txt
# myapp是你要建立的索引的app，note是你要建立索引的那个模型名（小写）
# title 和 content 两个字段添加到索引
{{ object.title }}
{{ object.content }}
```

```python
# community/search_indexes.py
# 先在search_indexes.py中写一个searchIndex
from haystack import indexes
from community.models import Topic

class TopicIndex(indexes.SearchIndex, indexes.Indexable):
    """topic index"""
    text = indexes.CharField(document=True, use_template=True)
    content = indexes.CharField(model_attr="content")
    # 下面这俩字段并没有在上面加索引，写他俩是因为后面的过滤filter和排序order_by用到
    # 注意：这里修改的话一定要重新建立索引，才能生效。python manage.py rebuild_index
    date_added = indexes.DateTimeField(model_attr="date_added")
    type = indexes.IntegerField(model_attr="type")

    def get_model(self):
        return Topic

    def index_queryset(self, using=None):
        return self.get_model().objects.all()
```

```python
# community/serializers.py
# 在serializers中写searchSerializer
from drf_haystack import serializers as HSER
from community.search_indexes import TopicIndex, ReviewIndex


class TopicIndexSer(HSER.HaystackSerializer):
    added = serializers.SerializerMethodField()             # 注意此处是一个额外添加的字段

    def to_representation(self, instance):
        # 注意这里的 instance.object 才是搜到的那个对象
        # (如果view里面的queryset是和rest-framework里的格式相同的话，instance才是搜到的那个对象)
        ret = super(TopicIndexSer, self).to_representation(instance)
        if isinstance(instance.object, Topic):
            ret["data"] = TopicSerializer(instance=instance.object).data
        else:
            ret["data"] = ReviewListSerializer(instance=instance.object).data
        return ret

    class Meta:
        # 这里用到了上面的SearchIndex
        index_classes = [TopicIndex]
        fields = ["content", "date_added", "type", "added"]
        # 这里可以写ignore_fields来忽略搜索那个字段

    def get_added(self, obj):   # 名字与字段相对应
        return "added"
```

```python
# community/views.py
# 在views.py中写类视图
from drf_haystack.viewsets import HaystackViewSet
from community.serializers import TopicIndexSer
from community.utils import MyPagination
from drf_haystack.filters import HaystackFilter, BaseHaystackFilterBackend

class ExtraPagination(PageNumberPagination):
    def get_paginated_response(self, data):
        keywords = self.request.query_params['text']
        if ' ' in keywords:
            seg_list = keywords.split(' ')

        return Response(OrderedDict([
            ('count', self.page.paginator.count),
            ('next', self.get_next_link()),
            ('previous', self.get_previous_link()),
            ('keywords', seg_list),
            ('results', data)           # 这里可以额外添加字段，是总的字段，不是每一个序列化对象对应的
        ]))

class ContentSearchViewSet(HaystackViewSet):
    # 这是自己根据 PageNumberPagination 写的分页类，照样适用
    pagination_class = ExtraPagination
    # 这里可以写多个模型，相应的：serializer里也可以写多个index_classes
    index_models = [Topic]
    serializer_class = TopicIndexSer
    # 这时filter，这里用到了type
    filter_backends = [HaystackFilter]
    filter_fields = ("type",)

    def get_queryset(self, index_models=[]):
        queryset = self.object_class()._clone()
        # 这时改写的get_queryset函数，用到了date_added
        # 如果上面没有把date_added和type加进去，这里是不能使用的
        queryset = queryset.models(*self.get_index_models()).order_by("-date_added")
        # queryset = queryset.models(*self.index_models).order_by("-date_added")
        return queryset

    def get_index_models(self):
        # 这是自己写的传入一个model参数，可以过滤掉不同的模型，配合上面的queryset使用
        model = self.request.query_params.get("model", None)
        di = {
            None: self.index_models,
            "topic": [Topic],
            "review": [Review]
        }
        return di.get(model, self.index_models)

    def filter_queryset(self, queryset: SearchQuerySet):
        # 一个钩子函数，可以自定义对应的行为
        for backend in list(self.filter_backends):
            builder = backend()
            applicable_filters, applicable_exclusions = builder.build_filters(self)
            queryset = builder.apply_filters(queryset, applicable_filters, applicable_exclusions)

        query = self.request.GET['text']

        app_filter = SQ()
        if ' ' in query:
            seg_list = query.split(' ')
            for key in seg_list:
                app_filter = app_filter | SQ(text=key)

        queryset = queryset.filter(app_filter)

        return queryset
```

```python
# community/urls.py
# 配置url
from rest_framework.router import DefaultRouter
from community.views import ContentSearchViewSet

router = DefaultRouter()
router.register(r"search", ContentSearchViewSet, base_name="search")
urlpatterns += router.urls
```