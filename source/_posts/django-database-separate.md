---
title: Django 多数据库联用
tags:
  - Django
mathjax: false
date: 2018-09-11 22:33:19
categories:
  - 研习
---

# Django 多数据库联用

有的时候我们需要在Django中同时使用多个数据库。本文记录相关操作。

<!-- more -->

# 设置多个数据库

```python
# project_name/setting.py

# 配置多个数据库
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.sqlite3',
        'NAME': os.path.join(BASE_DIR, 'db.sqlite3'),
    },
    'db1': {
        'ENGINE': 'django.db.backends.mysql',
        'NAME': 'dbname1',
        'USER': 'your_db_user_name',
        'PASSWORD': 'yourpassword',
        "HOST": "localhost",
    },
    'db2': {
        'ENGINE': 'django.db.backends.mysql',
        'NAME': 'dbname2',
        'USER': 'your_db_user_name',
        'PASSWORD': 'yourpassword',
        "HOST": "localhost",
    },
}
 
# 数据库路由
DATABASE_ROUTERS = ['project_name.database_router.DatabaseAppsRouter']

# 多个数据库的映射
DATABASE_APPS_MAPPING = {
    # example:
    #'app_name':'database_name',
    'app1': 'db1',
    'app2': 'db2',

    # Django Admin 相关设置
    # 'admin': 'default',
    # 'auth': 'default',
    # 'staticfiles': 'default',
    # 'sessions': 'default',
    # 'contenttypes': 'default',
    # 'messages': 'default',
}
```

# 配置路由

```python
# project_name/database_router.py
from django.conf import settings

DATABASE_MAPPING = settings.DATABASE_APPS_MAPPING

class DatabaseAppsRouter(object):
    """
    A router to control all database operations on models for different
    databases.

    In case an app is not set in settings.DATABASE_APPS_MAPPING, the router
    will fallback to the `default` database.

    Settings example:

    DATABASE_APPS_MAPPING = {'app1': 'db1', 'app2': 'db2'}
    """

    def db_for_read(self, model, **hints):
        """"Point all read operations to the specific database."""
        if model._meta.app_label in DATABASE_MAPPING:
            return DATABASE_MAPPING[model._meta.app_label]
        return None

    def db_for_write(self, model, **hints):
        """Point all write operations to the specific database."""
        if model._meta.app_label in DATABASE_MAPPING:
            return DATABASE_MAPPING[model._meta.app_label]
        return None

    def allow_relation(self, obj1, obj2, **hints):
        """Allow any relation between apps that use the same database."""
        db_obj1 = DATABASE_MAPPING.get(obj1._meta.app_label)
        db_obj2 = DATABASE_MAPPING.get(obj2._meta.app_label)
        if db_obj1 and db_obj2:
            if db_obj1 == db_obj2:
                return True
            else:
                return False
        return None

    def allow_syncdb(self, db, model):
        """Make sure that apps only appear in the related database."""

        if db in DATABASE_MAPPING.values():
            return DATABASE_MAPPING.get(model._meta.app_label) == db
        elif model._meta.app_label in DATABASE_MAPPING:
            return False
        return None

    def allow_migrate(self, db, app_label, model=None, **hints):
        """
        Make sure the auth app only appears in the 'auth_db'
        database.
        """
        if db in DATABASE_MAPPING.values():
            return DATABASE_MAPPING.get(app_label) == db
        elif app_label in DATABASE_MAPPING:
            return False
        return None
```

# 模型修改

```python
# models.py
class Users(models.Model):
    username = models.CharField(max_length=100)
    password = models.CharField(max_length=50)
    age = models.IntegerField()

    class Meta:
        app_label = "app1"          # 需要加上
```

# 数据迁移

```bash
./manage.py  migrate                        # 同步使用default的app
./manage.py  migrate --database=db01        # 同步使用db01的app
./manage.py  migrate --database=db02        # 同步使用db02的app
```