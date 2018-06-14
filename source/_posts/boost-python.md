---
title: Boost::Python 教程
tags:
  - Boost
  - Python
date: 2017-12-14 21:33:13
categories: 教程
---
# 简介
Boost.Python 是 Boost 中的一个组件，使用它能够大大简化用 C++ 与 Python 交互的步骤，提高开发效率。
<!-- more --> 

C++很快，Python很方便，在我们的编程过程中，有两种方式可以实现这一目标：

1. 使用C++扩展Python
2. 使用Python扩展C++

解释一下，使用C++扩展Python就是说，用C++写Python的模块供Python调用，最终我们
使用的语言是Python，而使用Python扩展就是说，我们将Python作为C++程序里面的
脚本语言，使用C++调用Python里面的库来使用，这样就可以在C++里面享受到Python包罗万象
的库了。

## CMake
在配置编译环境方面，我想最容易使用的还是CMake了吧，使用CMake可以很容易的的将项目的配置跨平台。

本项目的CMakeLists.txt如下：
```cmake
cmake_minimum_required(VERSION 3.9)             # CMake版本
project(BoostLearn)                             # 项目名称

set(CMAKE_CXX_STANDARD 11)                      # C++标准

# 我们需要将C++代码导出成动态链接库供Python使用
#---------------库名称-----库类型-----库源代码文件----
add_library(py_ext_greet SHARED py_ext_greet.cpp)
add_library(py_ext_class SHARED py_ext_class.cpp)

# 搜索Python3的解释器和库
find_package(PythonInterp 3 REQUIRED)
find_package(PythonLibs 3 REQUIRED)
IF (PYTHONLIBS_FOUND)
    # 导入Python库的头文件
    INCLUDE_DIRECTORIES(${PYTHON_INCLUDE_DIR})
    # 将Python库链接到我们的项目中去
    TARGET_LINK_LIBRARIES(py_ext_greet ${PYTHON_LIBRARY})
    TARGET_LINK_LIBRARIES(py_ext_class ${PYTHON_LIBRARY})
ENDIF ()

# Boost库设置，使用动态链接库
SET(Boost_USE_STATIC_LIBS OFF)
SET(Boost_USE_MULTITHREADED ON)
SET(Boost_USE_STATIC_RUNTIME OFF)
# 搜索Boost库Python模块
FIND_PACKAGE(Boost REQUIRED COMPONENTS python3)
IF (Boost_FOUND)
    # 导入Boost库的头文件
    INCLUDE_DIRECTORIES(${Boost_INCLUDE_DIRS})
    # 链接Boost库代码
    TARGET_LINK_LIBRARIES(py_ext_greet ${Boost_LIBRARIES})
    TARGET_LINK_LIBRARIES(py_ext_class ${Boost_LIBRARIES})
ENDIF ()

# 去掉默认的lib前缀
set_target_properties(py_ext_greet PROPERTIES PREFIX "")
set_target_properties(py_ext_class PROPERTIES PREFIX "")

# 拷贝python文件到输出文件夹
file(COPY "py_ext_greet.py" DESTINATION "./")
file(COPY "py_ext_class.py" DESTINATION "./")
```


# C++扩展Python

在这里，我们将会用到Boost库，使用Boost库的python模块，可以很方便的用C++来扩展Python。

## C++导出类

### 导出类成员函数

Boost库已经给我们封装的很好了，只要照着套路一步步操作即可。

```c++
#include <boost/python.hpp>
#include <string>

using namespace boost::python;

struct Student {
    Student(std::string name) : name(name) {}
    // 公开成员函数
    void set_name(std::string name) { this->name = name; }
    std::string get_name() { return name; }
    std::string name;
};

// 注意，这里并没有导出成员变量name
BOOST_PYTHON_MODULE (py_ext_class) {
    class_<Student>("Student", init<std::string>())
        .def("set_name", &Student::set_name)
        .def("get_name", &Student::get_name);
}
```

```python
# 导入我们在C++里面实现的类
from py_ext_class import Student, Var, Num, Pos

if __name__ == "__main__":
    # 初始化
    along = Student("along")
    print(along.get_name())
```

### 导出类公开成员变量

我们也经常会使用一些类仅仅有属性，而没有行为，比如长方形的宽和高之类，下面给出了一个实例：
分别导出了一个类的可变属性和一个常量属性，在Python里面我们可以尝试，name确实是无法被修改的。

```c++
#include <boost/python.hpp>
#include <string>

using namespace boost::python;

struct Var {
    Var(std::string name) : name(name), value() {};
    // 公开成员变量
    const std::string name;
    float value;
};

BOOST_PYTHON_MODULE (py_ext_class) {
    class_<Var>("Var", init<std::string>())
         .def_readonly("name", &Var::name)          // 常量属性
         .def_readwrite("value", &Var::value);      // 可变属性
}
```

```python
# 导入我们在C++里面实现的类
from py_ext_class import Var

if __name__ == "__main__":
    # Var实例
    x = Var("pi")
    x.value = 3.14

    # this is wrong, name is const
    # x.name = "hello"
```


### 导出类私有成员变量
有的时候，我们会把某些成员设置为私有成员，防止其封装性被破坏，如果对外get，set方法，那么也可以导出为Python的一个成员变量。

```c++
#include <boost/python.hpp>
#include <string>

using namespace boost::python;

struct Num {
    Num() : value() {}
    // 私有成员的get，set方法
    float get() const { return value; }
    void set(float value) { this->value = value; };
private:
    // 私有成员变量
    float value;
};

BOOST_PYTHON_MODULE (py_ext_class) {
    class_<Num>("Num")
        .add_property("rovalue", &Num::get)             // 只有get方法，无法修改
        .add_property("value", &Num::get, &Num::set);   // 和直接访问value基本一样
}
```

```python
# 导入我们在C++里面实现的类
from py_ext_class import Num

if __name__ == "__main__":
    # Num实例
    y = Num()
    y.value = 3.14
    print(y.value)
```


### 导出类运算符重载
和C++类似，Python也可以对不同的运算符进行重载，有了Boost的帮助，这一操作是非常简单的：

```c++
#include <boost/python.hpp>
#include <string>

using namespace boost::python;

class Pos {
public:
    Pos(int pos) : pos(pos) {}
    // 重载 + 运算符
    Pos operator+(int bias) {
        pos += bias;
        return *this;
    }
    int const get() { return pos; }
private:
    int pos;
};

BOOST_PYTHON_MODULE (py_ext_class) {
    class_<Pos>("Pos", init<int>())
        .add_property("pos", &Pos::get)
        .def(self + int());
}
```

```python
# 导入我们在C++里面实现的类
from py_ext_class import Pos

if __name__ == "__main__":
    # Pos运算符重载实例
    z = Pos(0)
    z = z + 5
    print(z.pos)
```

## C++导出函数
### C++导出静态函数

```c++
#include <boost/python.hpp>

// C函数导出
char const *greet() {
    return "Hello,Boost!";
}

// Boost模块 py_ext
BOOST_PYTHON_MODULE (py_ext_greet) {
    using namespace boost::python;
    def("greet", greet);
}
```

```python
from py_ext_greet import greet

if __name__ == "__main__":
    print(greet())

```

### C++导出默认参数(类初始化optional)
在C++中有些函数是带有默认参数的，如何将默认参数也导入到Python中呢？
参照如下实例:

```c++
#include <boost/python.hpp>
#include <string>

using namespace boost::python;

class Employee {
public:
    explicit Employee(std::string name, int wage = 3000) : name(name), wage(wage) {}

    int wage;
    std::string name;
};

BOOST_PYTHON_MODULE (py_ext_class) {
    class_<Employee>("Employee", init<std::string, optional<int>>()) // 注意optional中的是参数列表
        .def_readwrite("wage", &Employee::wage)
        .def_readwrite("name", &Employee::name);
}
```

```python
# 导入我们在C++里面实现的类
from py_ext_class import Employee

if __name__ == "__main__":
    # 默认初始化参数测试
    along = Employee("along")
    print(along.wage)
```

### C++导出默认参数(BOOST_PYTHON_FUNCTION_OVERLOADS)
对于如下普通的带有默认参数的函数，可以用如下宏进行导出包装：
```c++
int add(int a, int b, int c = 0, int d = 0) {
    return a + b + c + d;
}

// Boost会创建u一个新的包装类foo_overloads用于def,第三、四个参数是最小和最大参数数目，之后我们传入def就可以了。
BOOST_PYTHON_FUNCTION_OVERLOADS(add_overloads, add, 2, 4)

// Boost模块 py_ext_func
BOOST_PYTHON_MODULE (py_ext_func) {
    using namespace boost::python;
    def("greet", greet);
    def("add", add, add_overloads());
}
```
Python代码如下:
```python
from py_ext_func import add

if __name__ == "__main__":
    print(add(1, 2))
    print(add(1, 2, 3))
    print(add(1, 2, 3, 4))
```

### C++导出默认参数(BOOST_PYTHON_MEMBER_FUNCTION_OVERLOADS)
对于类内成员函数来说，我们要使用另外的宏进行包装，类似的：
```c++
struct george {
    void wack_em(int a, int b = 0, char c = 'x') {
        /*...*/
    }
};
```
使用如下：
```c++
BOOST_PYTHON_MEMBER_FUNCTION_OVERLOADS(george_overloads, wack_em, 1, 3)
// ...
    .def("wack_em", &george::wack_em, george_overloads());
```

# Python扩展C++
 **TODO**
