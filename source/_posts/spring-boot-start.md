---
title: Spring Boot起步
tags:
  - Spring Boot
date: 2017-09-22 08:25:42
categories: 学习
---
# Spring Boot简介
[Spring Boot](https://projects.spring.io/spring-boot/L)是由Pivotal团队提供的全新框架，其设计目的是用来简化新Spring应用的初始搭建以及开发过程。该框架使用了特定的方式来进行配置，从而使开发人员不再需要定义样板化的配置。通过这种方式，Boot致力于在蓬勃发展的快速应用开发领域（rapid application development）成为领导者。
<!-- more --> 

# 使用Maven构建项目
访问[Spring Starter](http://start.spring.io/)可以下载生成的项目，导入到项目里面即可。

Spring Boot的基础结构共三个文件:
+ src/main/java 程序开发以及主程序入口
+ src/main/resources 配置文件
+ src/test/java 测试程序

Sping Boot建议的目录结构如下：
```
com
  +- example
    +- myproject
      +- Application.java
      |
      +- domain
      |  +- Customer.java
      |  +- CustomerRepository.java
      |
      +- service
      |  +- CustomerService.java
      |
      +- controller
      |  +- CustomerController.java
      |
```
+ Application.java 建议放到根目录下面,主要用于做一些框架配置
+ domain目录主要用于实体（Entity）与数据访问层（Repository）
+ service 层主要是业务类代码
+ controller 负责页面访问控制

采用默认配置可以省去很多配置，当然也可以根据自己的喜欢来进行更改
最后，启动Application main方法，至此一个java项目搭建好了！

# 引入web模块
1. pom.xml中添加支持web的模块：
```xml
<dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-web</artifactId>
 </dependency>
```
pom.xml文件中默认有两个模块：
+ spring-boot-starter ：核心模块，包括自动配置支持、日志和YAML；
+ spring-boot-starter-test ：测试模块，包括JUnit、Hamcrest、Mockito。

2. 编写Controller内容
```java
@RestController
public class HelloWorldController {
    @RequestMapping("/hello")
    public String index() {
        return "Hello World";
    }
}
```
@RestController 的意思就是controller里面的方法都以json格式输出，不用再写什么jackjson配置的了！

3. 启动主程序，打开浏览器访问 http://localhost:8080/hello ，就可以看到效果了。

# 单元测试
打开的src/test/下的测试入口，编写简单的http请求来测试；使用mockmvc进行，利用MockMvcResultHandlers.print()打印出执行结果。
```java
@RunWith(SpringJUnit4ClassRunner.class)
@SpringApplicationConfiguration(classes = MockServletContext.class)
@WebAppConfiguration
public class HelloWorldControlerTests {
    private MockMvc mvc;
    @Before
    public void setUp() throws Exception {
        mvc = MockMvcBuilders.standaloneSetup(new HelloWorldController()).build();
    }
    @Test
    public void getHello() throws Exception {
    mvc.perform(MockMvcRequestBuilders.get("/hello").accept(MediaType.APPLICATION_JSON))
                .andExpect(MockMvcResultMatchers.status().isOk())
                .andDo(MockMvcResultHandlers.print())
                .andReturn();
    }
}
```

# 开发环境调试
热启动在正常开发项目中已经很常见了吧，虽然平时开发web项目过程中，改动项目启重启总是报错；但springBoot对调试支持很好，修改之后可以实时生效，需要添加以下的配置：
```xml
 <dependencies>
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-devtools</artifactId>
        <optional>true</optional>
    </dependency>
</dependencies>

<build>
    <plugins>
        <plugin>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-maven-plugin</artifactId>
            <configuration>
                <fork>true</fork>
            </configuration>
        </plugin>
</plugins>
</build>
```
该模块在完整的打包环境下运行的时候会被禁用。如果你使用java -jar启动应用或者用一个特定的classloader启动，它会认为这是一个“生产环境”。

# 总结
使用spring boot可以非常方便、快速搭建项目，使我们不用关心框架之间的兼容性，适用版本等各种问题，我们想使用任何东西，仅仅添加一个配置就可以，所以使用sping boot非常适合构建微服务。
