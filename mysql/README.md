# MySQL基础篇

## 1. MySQL概述

### 1.1 数据库相关概念

| 名称           | 全称                                                         | 简称                              |
| -------------- | ------------------------------------------------------------ | --------------------------------- |
| 数据库         | 存储数据的仓库，数据是有组织的进行存储                       | DataBase（DB）                    |
| 数据库管理系统 | 操纵和管理数据库的大型软件                                   | DataBase Management System (DBMS) |
| SQL            | 操作关系型数据库的编程语言，定义了一套操作关系型数据库统一 标准 | Structured Query Language (SQL)   |

### 1.2 下载安装

Windows：

[https://blog.csdn.net/qq_44870331/article/details/120834643](https://blog.csdn.net/qq_44870331/article/details/120834643)

CentOS:

[https://blog.csdn.net/qq_44870331/article/details/139699155](https://blog.csdn.net/qq_44870331/article/details/139699155)

## 2. SQL

全称 Structured  Query Language，结构化查询语言。操作关系型数据库的编程语言，定义了一套操作关系型数据库统一标准。

### 2.1 SQL通用语法

- 单行或多行书写，以分号结尾。
- 可使用空格、缩进增强语句可读性。
- MySQL 语句不区分大小写，关键字推荐用大写
- 注释
  - 单行注释：-- 注释内容 或 # 注释内容
  - 多行注释：/* 注释内容 */

### 2.2 SQL分类

| 分类 |            全称            |                          说明                          |
| :--: | :------------------------: | :----------------------------------------------------: |
| DDL  |  Data Definition Language  |  数据定义语言，用来定义数据库对象（数据库、表、字段）  |
| DML  | Data Manipulation Language |     数据操作语言，用来对数据库表中的数据进行增删改     |
| DQL  |    Data Query Language     |         数据查询语言，用来查询数据库中表的记录         |
| DCL  |   Data Control Language    | 数据控制语言，用来创建数据库用户、控制数据库的控制权限 |

### 2.3 DDL（数据定义语言）

Data Definition Language，数据定义语言，用来定义数据库对象(数据库，表，字段) 。

#### 2.3.1 数据库操作

- 查询所有数据库:
  `SHOW DATABASES;`  

- 查询当前数据库：
  `SELECT DATABASE();`  

- 创建数据库：
  `CREATE DATABASE [ IF NOT EXISTS ] 数据库名 [ DEFAULT CHARSET 字符集] [COLLATE 排序规则 ];` 
  -  create database IF NOT EXISTS emp default charset utf8mb4 COLLATE utf8mb4_unicode_ci;

- 删除数据库:
  `DROP DATABASE [ IF EXISTS ] 数据库名;`  

- 使用数据库：
  `USE 数据库名;`

**注意事项**

- UTF8字符集长度为3字节，有些符号占4字节，所以推荐用utf8mb4字符集

#### 2.3.2 排序规则

>COLLATE：排序规则
>
>通常是和数据编码（CHARSET）相关的，字符串的物理存储由排序规则控制。
>COLLATE是一个子句，可应用于数据库定义或列定义，或应用于字符串表达式以应用排序规则投影。
>
>可以用来比较一些复杂排序。如VARCHAR，CHAR，TEXT类型，不区分大小写等的列，都需要有一个COLLATE类型来告知MySQL如何对该列进行排序和比较。
>
>简述，COLLATE会影响 ORDER BY 语句顺序，会影响 WHERE 条件中大于小于号筛选出来的结果，会影响 `DISTINCT、GROUP BY、HAVING`语句的查询结果，会影响任意查询排序结果。

官方文档：[https://dev.mysql.com/doc/refman/8.4/en/charset.html](https://dev.mysql.com/doc/refman/8.4/en/charset.html)

使用方法：设置级别及其优先级

>设置COLLATE可以在示例级别、库级别、表级别、列级别、以及SQL指定。

```mysql
# 数据库级别
CREATE DATABASE 数据库名 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
# 数据表级别
CREATE TABLE(
...
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
# 数据列级别
# 如果列级别没有设置CHARSET和COLATE，则列级别会继承表级别的CHARSET与COLLATE。
CREATE TABLE (
`字段` VARCHAR（100） CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
……
) ……
```

排序规则[命名约定](https://dev.mysql.com/doc/refman/8.4/en/charset-collation-names.html)：

| 后缀 | 含义                             |
| ---- | -------------------------------- |
| _as  | 口音敏感                         |
| _cs  | 区分大小写                       |
| _bin | 指定使用向后兼容的二进制排序顺序 |

查询排序：

```mysql
# 查询所有的字符集
SHOW CHARACTER SET;
# 查询所有的排序集
SHOW COLLATION;
# 查询'utf8mb4'编码时可用的排序集
SHOW COLLATION WHERE CHARSET = 'utf8mb4';

# 例如:名称根据中文排序(不考虑多音字)
# 升序
SELECT * FROM TABLE_NAME ORDER BY CONVERT(NAME USING GBK) COLLATE GBK_CHINESE_CI ASC
# 降序
SELECT * FROM TABLE_NAME ORDER BY CONVERT(NAME USING GBK) COLLATE GBK_CHINESE_CI DESC

```

#### 2.3.3 表操作

##### 2.3.3.1 查询创建

- 查询当前数据库所有表：

  `USE 库名;`

  `SHOW TABLES;`  

- 查询表结构：
  `DESC 表名;`  

- 查询指定表的建表语句：
  `SHOW CREATE TABLE 表名;`  

- 创建表：

```mysql
CREATE TABLE 表名(
	字段1 字段1类型 [COMMENT 字段1注释],
	字段2 字段2类型 [COMMENT 字段2注释],
	字段3 字段3类型 [COMMENT 字段3注释],
	...
	字段n 字段n类型 [COMMENT 字段n注释]
)[ COMMENT 表注释 ];
```

> 需用英文格式,最后一个字段后面没有逗号

```mysql
create table tb_user(
       	id int comment '编号',
		name varchar(100) comment '姓名',
       	age int comment '年龄',
 		gender varchar(1) comment '性别'
) comment
```

##### 2.3.3.2 数据类型

①数值类型：

|   分类   |     类型     | 大小    | 有符号（SIGNED）范围                                  | 无符号（UNSIGNED）范围                                  | 描述                 |
| :------: | :----------: | ------- | ----------------------------------------------------- | ------------------------------------------------------- | -------------------- |
| 数值类型 |   TINYINT    | 1 byte  | (-128,127)                                            | (0，255)                                                | 小整数值             |
|          |   SMALLINT   | 2 bytes | (-32768,32767)                                        | (0，65535)                                              | 大整数值             |
|          |  MEDIUMINT   | 3 bytes | (-8388608,8388607)                                    | (0，16777215)                                           | 大整数值             |
|          | INT或INTEGER | 4 bytes | (-2147483648,2147483647)                              | (0，4294967295)                                         | 大整数值             |
|          |    BIGINT    | 8 bytes | (-2^63, 2^63-1)                                       | (0，2^64-1)                                             | 极大整数值           |
|          |    FLOAT     | 4 bytes | (-3.402823466E+38,3.402823466E+38)                    | 0 和    (1.175494351 E-38，3.402823466 E+38)            | 单精度浮点数值       |
|          |    DOUBLE    | 8 bytes | (-1.7976931348623157 E+308，1.7976931348623157 E+308) | 0和(2.2250738585072014 E-308，1.7976931348623157 E+308) | 双精度浮点数值       |
|          |   DECIMAL    |         | 依赖于M(精度)和D(标度) 的值                           | 依赖于M(精度)和D(标度)的值                              | 小数值（精确定点数） |

> 1). 年龄字段    -- 不会出现负数, 而且人的年龄不会太大
>
> age tinyint unsigned
>
> 2). 分数    -- 总分100分, 最多出现一位小数(允许1位小数，100.0)
>
> score double(4,1)

②字符串类型：

| 类型       | 大小                  | 描述                         |
| ---------- | --------------------- | ---------------------------- |
| CHAR       | 0-255 bytes           | 定长字符串(需要指定长度)     |
| VARCHAR    | 0-65535 bytes         | 变长字符串(需要指定长度)     |
| TINYBLOB   | 0-255 bytes           | 不超过255个字符的二进制数据  |
| TINYTEXT   | 0-255 bytes           | 短文本字符串                 |
| BLOB       | 0-65 535 bytes        | 二进制形式的长文本数据       |
| TEXT       | 0-65 535 bytes        | 长文本数据                   |
| MEDIUMBLOB | 0-16 777 215 bytes    | 二进制形式的中等长度文本数据 |
| MEDIUMTEXT | 0-16 777 215 bytes    | 中等长度文本数据             |
| LONGBLOB   | 0-4 294 967 295 bytes | 二进制形式的极大文本数据     |
| LONGTEXT   | 0-4 294 967 295 bytes | 极大文本数据                 |

char 与 varchar 都可以描述字符串，

- char是定长字符串，指定长度多长，就占用多少个字符，和 字段值的长度无关 。

- 而varchar是变长字符串，指定的长度为最大占用长度。相对来说，char的性能会更高些。

> 1). 用户名    username ------> 长度不定, 最长不会超过50
>
> username varchar(50)
>
> 2). 性别    gender ---------> 存储值, 不是男,就是女
>
> gender char(1)
>
> 3). 手机号    phone --------> 固定长度为11
>
> phone char(11)

③日期时间类型

| 类型      | 大小 | 范围                                       | 格式                | 描述                     |
| --------- | ---- | ------------------------------------------ | ------------------- | ------------------------ |
| DATE      | 3    | 1000-01-01 至 9999-12-31                   | YYYY-MM-DD          | 日期值                   |
| TIME      | 3    | -838:59:59 至 838:59:59                    | HH:MM:SS            | 时间值或持续时间         |
| YEAR      | 1    | 1901 至 2155                               | YYYY                | 年份值                   |
| DATETIME  | 8    | 1000-01-01 00:00:00 至 9999-12-31 23:59:59 | YYYY-MM-DD HH:MM:SS | 混合日期和时间值         |
| TIMESTAMP | 4    | 1970-01-01 00:00:01 至 2038-01-19 03:14:07 | YYYY-MM-DD HH:MM:SS | 混合日期和时间值，时间戳 |

> 1). 生日字段    birthday
>
> birthday date
>
> 2). 创建时间    createtime
>
> createtime  datetime

##### 2.3.3.3 案例：

设计一张员工信息表，要求如下： 
1. 编号（纯数字）
2. 员工工号 (字符串类型，长度不超过10位)
3. 员工姓名（字符串类型，长度不超过10位）
4. 性别（男/女，存储一个汉字）
5. 年龄（正常人年龄，不可能存储负数）
6. 身份证号（二代身份证号均为18位，身份证中有X这样的字符）
7. 入职时间（取值年月日即可）

```mysql
CREATE TABLE emp (
  id INT COMMENT '编号',
  workno VARCHAR(10) COMMENT '员工工号',
  username VARCHAR(10) COMMENT '员工姓名',
  gender CHAR(1) COMMENT '性别',
  age TINYINT(3) COMMENT '年龄',
  idcard CHAR(18) COMMENT '身份证号',
  entrydate DATE COMMENT '入职时间'
  ) COMMENT '员工表';
```

查看表结构：DESC emp;

##### 2.3.3.4 修改

① 添加字段：

```mysql
ALTER TABLE 表名 ADD 字段名 类型(长度)[COMMENT 注释][约束];
```

> 为emp表添加新字段“呢称”nickname,类型为varchar(20)
>
> ```mysql
> ALTER TABLE emp ADD nickname VARCHAR(20) COMMENT '呢称'; 
> ```

② 修改数据类型：

```mysql
ALTER TABLE 表名 MODIFY 字段名 新数据类型（长度）
```

③ 修改字段名和字段类型

```mysql
ALTER TABLE 表名 CHANGE 旧字段名 新字段名 类型（长度）[COMMENT  注释][约束];
```

> 将emp表的nickname字段修改为username，类型为varchar(30)
>
> ```mysql
> ALTER TABLE emp CHANGE nickname username varchar(30) comment '呢称';
> ```

④ 删除字段

```mysql
ALTER TABLE 表名 DROP 字段名;
```

> 将emp表字段username删除
>
> ```mysql
> ALTER TABLE emp DROP username;
> ```

⑤ 修改表名

```mysql
ALTER TABLE 表名 RENAME TO 新表名;
```

> 将emp表名改为emps
>
> ```mysql
> ALTER TABLE emp RENAME TO emps;
> ```

##### 2.3.3.5 删除

① 删除表

```mysql
DROP TABLE [IF EXISTS] 表名;
```

> 如果tb_user表存在，则删除tb_user表
>
> ```mysql
> DROP TABLE IF EXISTS tb_user;
> ```

 ② 删除指定表，并重新创建表（似清空表数据）

```mysql
TRUNCATE TABLE 表名;
```

> 慎用，会将表中数据全部清除。

### 2.4 DML

DML英文全称是Data Manipulation Language(数据操作语言)，用来对数据库中表的数据记录进行增、删、改操作。

- 添加数据（INSERT） 
- 修改数据（UPDATE） 
- 删除数据（DELETE）

##### 2.4.1 添加数据

① 给指定字段添加数据

```
INSERT INTO 表名（字段名1, 字段名2, ...） VALUES (值1, 值2, ...);
```

> 给emps表所有字段添加数据
>
> ```mysql
> INSERT INTO emps(id,workno,name,gender,age,idcard,entrydate) VALUES(1,'1','coisini','男',20,'987654321012345678','2000-01-01');
> ```
>
> 查询
>
> ```mysql
> SELECT * FROM emps;
> ```

② 给全部字段添加数据

```mysql
INSERT INTO 表名 VALUES(值1，值2，...);
```

> 插入数据到emps表
>
> ```mysql
> INSERT INTO emps VALUE(2,'2','萧萧','男',18,'987654321012345678','2001-01-01');
> ```

③ 批量添加数据

```mysql
INSERT INTO 表名(字段名1,字段名2,...) VALUES(值1,值2,...),(值1,值2,...),(值1,值2,...);
```

> 批量插入数据到emps表
>
> ```mysql
> INSERT INTO emps VALUES(3,'3','3号员工','女',20,'123456789123456789','2000-12-12'),(4,'4','4号员工','女',19,'123456789123456780','2000-09-09'),(5,'5','5号员工','女',21,'123456789123456700','2000-05-12');
> ```
>
> - 插入数据时，指定字段顺序需要玉值顺序一一对应
> - `字符串和日期型数据应该包含在引号中`
> - 插入数据大小应在字段规定范围内

##### 2.4.2 修改数据

```mysql
UPDATE 表名 SET 字段名1 = 值1, 字段名2 = 值2,...[WHERE 条件];
```

> 将id为1的name字段值修改为 coisini.cn
>
> ```mysql
> UPDATE emps SET name = 'coisini.cn' WHERE id = 1;
> ```
>
> 将id为1的name字段值修改为 小小，gender修改为 女
>
> ```mysql
> UPDATE emps SET name = '小小',gender = '女' WHERE id = 1;
> ```
>
> 修改`所有员工`入职日期为：2002-02-02
>
> ```mysql
> UPDATE emps SET entrydate = '2002-02-02';
> ```
>
> - 修改语句未添加条件会修改整张表数据

##### 2.4.3 删除数据

```mysql
DELETE FROM 表名 [WHERE 条件];
```

> 删除gender为 男 的员工
>
> ```mysql
> DELETE FROM emps WHERE gender = '男';
> ```
>
> 删除所有员工
>
> ```mysql
> DELETE FROM emps;
> ```
>
> - DELETE语句不加条件会删除整张表数据
> - 不能删除某一个字段的值（可以使用UPDATE将字段设置为NULL）
> - 全表删除需谨慎

#### 2.5 DQL

DQL英文全称是Data Query Language(数据查询语言)，数据查询语言，用来查询数据库中表的记录。

查询关键字: SELECT

在一个正常的业务系统中，查询操作的频次是要远高于增删改的，当我们去访问企业官网、电商网站， 
在这些网站中我们所看到的数据，实际都是需要从数据库中查询并展示的。而且在查询的过程中，可能 
还会涉及到条件、排序、分页等操作。

数据准备：

>```mysql
>DROP TABLE IF EXISTS emps;
>
>CREATE TABLE emps(
>	id int COMMENT '编号',
>    workno varchar(10) COMMENT '工号',
>    name varchar(10) COMMENT '姓名',
>    gender char(1) COMMENT '性别',
>    age tinyint UNSIGNED COMMENT '年龄',
>    idcard char(18) COMMENT '身份证号',
>    workaddress varchar(50) COMMENT '工作地址',
>    entrydate date COMMENT '入职时间'
>) COMMENT '员工表';
>
>
>INSERT INTO emps (id, workno, name, gender, age, idcard, workaddress, entrydate) VALUES (1, '00001', '0011', '女', 20, '123456789012345678', '北京', '2000-01-01');
>INSERT INTO emps (id, workno, name, gender, age, idcard, workaddress, entrydate) VALUES (2, '00002', '张无忌', '男', 18, '123456789012345670', '北京', '2005-09-01');
>INSERT INTO emps (id, workno, name, gender, age, idcard, workaddress, entrydate) VALUES (3, '00003', '韦一笑', '男', 38, '123456789712345670', '上海', '2005-08-01');
>INSERT INTO emps (id, workno, name, gender, age, idcard, workaddress, entrydate) VALUES (4, '00004', '赵敏', '女', 18, '123456757123845670', '北京', '2009-12-01');
>INSERT INTO emps (id, workno, name, gender, age, idcard, workaddress, entrydate) VALUES (5, '00005', '小昭', '女', 16, '123456769012345678', '上海', '2007-07-01');
>INSERT INTO emps (id, workno, name, gender, age, idcard, workaddress, entrydate) VALUES (6, '00006', '杨逍', '男', 28, '12345678931234567X', '北京', '2006-01-01');
>INSERT INTO emps (id, workno, name, gender, age, idcard, workaddress, entrydate) VALUES (7, '00007', '范瑶', '男', 40, '123456789212345670', '北京', '2005-05-01');
>INSERT INTO emps (id, workno, name, gender, age, idcard, workaddress, entrydate) VALUES (8, '00008', '黛绮丝', '女', 38, '123456157123645670', '天津', '2015-05-01');
>INSERT INTO emps (id, workno, name, gender, age, idcard, workaddress, entrydate) VALUES (9, '00009', '范凉凉', '女', 45, '123156789012345678', '北京', '2010-04-01');
>INSERT INTO emps (id, workno, name, gender, age, idcard, workaddress, entrydate) VALUES (10, '00010', '陈友谅', '男', 53, '123456789012345670', '上海', '2011-01-01');
>INSERT INTO emps (id, workno, name, gender, age, idcard, workaddress, entrydate) VALUES (11, '00011', '张士诚', '男', 55, '123567897123465670', '江苏', '2015-05-01');
>INSERT INTO emps (id, workno, name, gender, age, idcard, workaddress, entrydate) VALUES (12, '00012', '常遇春', '男', 32, '123446757152345670', '北京', '2004-02-01');
>INSERT INTO emps (id, workno, name, gender, age, idcard, workaddress, entrydate) VALUES (13, '00013', '张三丰', '男', 88, '123656789012345678', '江苏', '2020-11-01');
>INSERT INTO emps (id, workno, name, gender, age, idcard, workaddress, entrydate) VALUES (14, '00014', '灭绝', '女', 65, '123456719012345670', '西安', '2019-05-01');
>INSERT INTO emps (id, workno, name, gender, age, idcard, workaddress, entrydate) VALUES (15, '00015', '胡青牛', '男', 70, '12345674971234567X', '西安', '2018-04-01');
>INSERT INTO emps (id, workno, name, gender, age, idcard, workaddress, entrydate) VALUES (16, '00016', '周芷若', '女', 18, null, '北京', '2012-06-01');
>```

##### 2.5.1 基本语法

```mysql
SELECT
	字段列表
FROM
	表名列表
WHERE
	条件列表
GROUP BY
	分组字段列表
HAVING
	分组后条件列表
ORDER BY
	排序字段列表
LIMIT
	分页参数
```

>基本查询（不带任何条件） 
>条件查询（WHERE）
>聚合函数（count、max、min、avg、sum） 
>分组查询（group by）
>排序查询（order by） 
>分页查询（limit）

##### 2.5.2 基本查询

不带条件查询

① 查询多个字段

```mysql
SELECT 字段1,字段2,字段3... FROM 表名;
```

```mysql
SELECT * FROM 表名;
```

> 需少用*，查询指定字段效率会高一些。

② 字段设置别名

```mysql
SELECT 字段1 [AS 别名1], 字段2 [AS 别名2] ... FROM 表名; 
```

```mysql
SELECT 字段1 [别名1], 字段2 [别名2] ... FROM 表名;
```

③ 去除重复记录

```mysql
SELECT DISTINCT 字段列表 FROM 表名;
```

> 相关案例：
>
> - 查询指定字段 name, workno, age并返回
>
>   ```mysql
>   SELECT name, workno, age FROM emps;
>   ```
>
> - 查询所有字段
>
>   ```mysql
>   SELECT id,workno,name,gender,age,idcard,workaddress,entrydate FROM emps;
>   ```
>
>   ```mysql
>   SELECT * FROM emps;
>   ```
>
> - 查询所有员工的工作地址，起别名
>
>   ```mysql
>   SELECT workaddress as '工作地址' from emps;
>   ```
>
>   > as 可省略
>
> - 查询公司员工上班地址有哪些（去重）
>
>   ```mysql
>   SELECT DISTINCT workaddress '工作地址' FROM emps;
>   ```

##### 2.5.3 条件查询

语法：

> ```mysql
> SELECT 字段列表 FROM 表名 WHERE 条件列表;
> ```

条件：

- 比较运算符

  | 比较运算符       | 功能                                       |
  | ---------------- | ------------------------------------------ |
  | >                | 大于                                       |
  | >=               | 大于等于                                   |
  | <                | 小于                                       |
  | <=               | 小于等于                                   |
  | =                | 等于                                       |
  | <> 或 !=         | 不等于                                     |
  | BETWEEN...AND... | 在某个范围之内（含最小、最大值）           |
  | IN(...)          | 在in之后的列表中的值，多选一               |
  | LIKE 占位符      | 模糊匹配（_匹配单个字符，%匹配任意个字符） |
  | IS NULL          | 是NULL                                     |

- 逻辑运算符

  | 逻辑运算符 | 功能                         |
  | ---------- | ---------------------------- |
  | AND 或 &&  | 并且（多个条件同时成立）     |
  | OR 或 \|\| | 或者（多个条件任意一个成立） |
  | NOT 或 !   | 非，不是                     |

> 相关案例：
>
> - 查询年龄等于88的员工
>
>   ```mysql
>   SELECT * FROM emps WHERE age = 88;
>   ```
>
> - 查询年龄小于20的员工信息
>
>   ```mysql
>   SELECT * FROM emps WHERE age < 20;
>   ```
>
> - 查询年龄小于等于20的员工信息
>
>   ```mysql
>   SELECT * FROM emps WHERE age <= 20;
>   ```
>
> - 查询没有身份证号的员工
>
>   ```mysql
>   SELECT * FROM emps WHERE idcard IS null;
>   ```
>
> - 查询有身份证号的员工
>
>   ```mysql
>   SELECT * FROM emps WHERE idcard IS NOT null;
>   ```
>
> - 查询年龄不等于88的员工
>
>   ```mysql
>   SELECT * FROM emps WHERE age != 88;
>   SELECT * FROM emps WHERE age <> 88;
>   ```
>
> - 查询年龄在15岁（包含）到20岁（包含）之间的员工信息
>
>   ```mysql
>   SELECT * FROM emps WHERE age >= 15 && age <= 20;
>   SELECT * FROM emps WHERE age >= 15 AND age <= 20;
>   SELECT * FROM emps WHERE age BETWEEN 15 AND 20;
>   ```
>
> - 查询性别为 女 且 年龄小于 25岁的员工信息
>
>   ```mysql
>   SELECT * FROM emps WHERE gender = '女' AND age < 25;
>   SELECT * FROM emps WHERE gender = '女' && age < 25;
>   ```
>
> - 查询年龄等于 18 或 20 或 40 的员工信息
>
>   ```mysql
>   SELECT * FROM emps WHERE age = 18 OR age = 20 OR age = 40;
>   SELECT * FROM emps WHERE age = 18 || age = 20 || age = 40;
>   SELECT * FROM emps WHERE age IN(18,20,40);
>   ```
>
> - 查询姓名为两个字的员工信息
>
>   ```MYSQL
>   SELECT * FROM emps WHERE name LIKE '__';
>   ```
>
> - 查询身份证号最后一位是X的员工信息
>
>   ```mysql
>   SELECT * FROM emps WHERE idcard LIKE '%X';
>   SELECT * FROM emps WHERE idcard LIKE '_________________X';
>   ```

##### 2.5.4 聚合函数

> 将一列数据作为一个整体，进行纵向计算。

| 函数  | 功能     |
| ----- | -------- |
| count | 统计数量 |
| max   | 最大值   |
| min   | 最小值   |
| avg   | 平均值   |
| sum   | 求和     |

语法：

```mysql
SELECT 聚合函数(字段列表) FROM 表名;
```

> null值不参与所有聚合函数运算
>
> - 统计该企业员工数量
>
>   ```mysql
>   SELECT COUNT(*) FROM emps;
>   ```
>
> - 统计idcard字段不为null数
>
>   ```mysql
>   SELECT COUNT(idcard) FROM emps;
>   ```
>
> 对于count聚合函数，统计符合条件的记录数，还可通过count(数字/字符串)形式进行查询，例如：
>
> ```mysql
> SELECT COUNT(1) FROM emps;
> ```
>
> - 统计该企业员工平均年龄
>
>   ```mysql
>   SELECT AVG(age) FROM emps;
>   ```
>
> - 统计该企业员工最大年龄
>
>   ```mysql
>   SELECT MAX(age) FROM emps;
>   ```
>
> - 统计该企业员工最小年龄
>
>   ```mysql
>   SELECT MIN(age) FROM emps;
>   ```
>
> - 统计该企业西安地区员工年龄之和
>
>   ```mysql
>   SELECT SUM(age) FROM emps WHERE workaddress = '西安';
>   ```

##### 2.5.5 分组查询

```mysql
SELECT 字段列表 FROM 表名 [WHERE 条件] GROUP BY 分组字段名 [HAVING 分组后过滤条件];
```

WHERE 与 HAVING 区别

- 执行时机不同：WHERE是分组之前过滤，不满足WHERE条件不参与分组；HAVING是分组之后对结果过滤。
- 判断条件不同：WHERE不能对聚合函数进行判断，而HAVING可以

> - 分组之后，查询的字段一般为聚合函数和分组字段，查询其他字段无意义。
>
> - 执行顺序：WHERE > 聚合函数 > HAVING。
> - 支持多字段分组，具体语法为：GROUP BY columnA,columnB

**相关案例：**

> - 根据性别分组，统计男性员工和女性员工的数量
>
>   ```mysql
>   SELECT gender, COUNT(*) FROM emps GROUP BY gender;
>   ```
>
> - 根据性别分组，统计男性员工和女性员工的平均年龄
>
>   ```mysql
>   SELECT gender, AVG(age) FROM emps GROUP BY gender;
>   ```
>
> - 查询年龄小于45的员工, 并根据工作地址分组, 获取员工数量大于等于3的工作地址
>
>   ```mysql
>   SELECT workaddress, COUNT(*) address_count FROM emps WHERE age < 45 GROUP BY workaddress HAVING address_count >=3;
>   ```
>
> - 统计各个工作地址上班的男性及女性员工的数量
>
>   ```mysql
>   SELECT workaddress,gender,COUNT(*) '数量' FROM emps GROUP BY workaddress,gender;
>   ```

##### 2.5.6 排序查询

升序排序（ASC 默认）、降序排序（DESC）

```mysql
SELECT 字段列表 FROM 表名 ORDER BY 字段1 排序方式1, 字段2 排序方式2;
```

> 升序可不指定ASC
>
> 多字段排序，当第一个字段值相同时，才会根据第二个字段进行排序

相关案例：

> - 根据年龄对公司的员工进行升序排序
>
>   ```mysql
>   SELECT * FROM emps ORDER BY age ASC;
>   SELECT * FROM emps ORDER BY age
>   ```
>
> - 根据入职时间, 对员工进行降序排序
>
>   ```mysql
>   SELECT * FROM emps ORDER BY entrydate DESC;
>   ```
>
> - 根据年龄对公司的员工进行升序排序, 年龄相同, 再按照入职时间进行降序排序
>
>   ```mysql
>   SELECT * FROM emps ORDER BY age ASC, entrydate DESC;
>   ```

##### 2.5.7 分页查询

```mysql
SELECT 字段列表 FROM 表名 LIMIT 起始索引, 查询记录数;
```

> - 起始索引从0开始，起始索引 = （查询页码 - 1）* 每页显示记录数。
> - 分页查询是数据库方言，不同数据库有不同的实现，MySQL中是LIMIT。
> - 如果查询的是第一页数据，起始索引可以省略，简写为LIMIT 10。

相关案例：

> - 查询第1页员工数据, 每页展示10条记录
>
>   ```mysql
>   SELECT * FROM emps LIMIT 0, 10;
>   SELECT * FROM emps LIMIT 10;
>   ```
>
> - 查询第2页员工数据, 每页展示10条记录 `(页码-1) * 页展示记录数`
>
>   ```mysql
>   SELECT * FROM emps LIMIT 10,10;
>   ```

##### 2.5.8 综合案例：

- 查询年龄为20,21,22,23岁的 女员工信息。

  ```mysql
  SELECT * FROM emps WHERE gender = '女' AND age IN(20,21,22,23);
  SELECT * FROM emps WHERE gender = '女' AND age = 20 OR age = 21 OR age = 22 OR age = 23;
  ```

- 查询性别为男，并且年龄在20-40 岁(含)以内的姓名为三个字的员工。

  ```mysql
  SELECT * FROM emps WHERE gender = '男' AND( age BETWEEN 20 AND 40 ) AND name LIKE '___';
  ```

- 统计员工表中, 年龄小于60岁的, 男性员工和女性员工的人数。

  ```mysql
  SELECT gender, COUNT(*) FROM emps WHERE age < 60 GROUP BY gender;
  ```

- 查询所有年龄小于等于35岁员工的姓名和年龄，并对查询结果按年龄升序排序，如果年龄相同按入职时间降序排序。

  ```mysql
  SELECT name, age FROM emps WHERE age <= 35 ORDER BY age ASC, entrydate DESC;
  ```

- 查询性别为男，且年龄在20-40 岁(含)以内的前5个员工信息，对查询的结果按年龄升序排序，年龄相同按入职时间升序排序。

  ```mysql
  SELECT * FROM emps WHERE gender = '男' AND (age BETWEEN 20 AND 40)ORDER BY age ASC, entrydate DESC LIMIT 0,5;
  ```

##### 2.5.9 执行顺序

编写顺序：

```mysql
SELECT
	字段列表
FROM
	表名列表
WHERE
	条件列表
GROUP BY
	分组字段列表
HAVING
	分组后条件列表
ORDER BY
	排序字段列表
LIMIT
	分页参数
```

**执行顺序：**

```mysql
FROM
	表名列表
WHERE
	条件列表
GROUP BY
	分组字段列表
HAVING
	分组后条件列表
SELECT
	字段列表
ORDER BY
	排序字段列表
LIMIT
	分页参数
```

> 相关示例：
>
> - 查询年龄大于15的员工姓名、年龄，并根据年龄进行升序排序。
>
>   ```mysql
>   SELECT name,age FROM emps WHERE age >15 ORDER BY age ASC;
>   ```
>
> - 给emp表起一个别名e，然后在select及where中使用该别名
>
>   ```mysql
>   SELECT e.name,e.age FROM emps e WHERE e.age >15 ORDER BY e.age ASC;
>   ```
>
>   >from ... where ... group by ... having ... select ... order by ... limit ...





