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

#### 2.4.1 添加数据

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

#### 2.4.2 修改数据

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

#### 2.4.3 删除数据

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

### 2.5 DQL

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

#### 2.5.1 基本语法

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

#### 2.5.2 基本查询

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

#### 2.5.3 条件查询

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

#### 2.5.4 聚合函数

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

#### 2.5.5 分组查询

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

#### 2.5.6 排序查询

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

#### 2.5.7 分页查询

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

#### 2.5.8 综合案例：

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

#### 2.5.9 执行顺序

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

### 2.6 DCL

>DCL英文全称是 Data Control Language(数据控制语言)，用来管理数据库用户、控制数据库的访问权限。

#### 2.6.1 管理用户

- 查询用户

  ```mysql
  SELECT * FROM mysql.user;
  ```

>其中 Host代表当前用户访问的主机, 如果为localhost, 仅代表只能够在当前本机访问，是不可以远程访问的。 User代表的是访问该数据库的用户名。在MySQL中需要通过Host和User来唯一标识一个用户。

- 创建用户

  ```mysql
  CREATE USER '用户名'@'主机名' IDENTIFIED BY '密码';
  ```

- 修改用户密码

  ```mysql
  ALTER USER '用户名'@'主机名' IDENTIFIED WITH mysql_native_password BY '新密码';
  ```

- 删除密码

  ```mysql
  DROP USER '用户名'@'主机名';
  ```

> - 在MySQL中需要通过用户名@主机名的方式，来唯一标识一个用户。
> - 主机名可以使用 % 通配。
> - 这类SQL开发人员操作的比较少，主要是DBA（Database Administrator 数据库管理员）使用。

**相关案例：**

① 创建用户coisini, 只能够在当前主机localhost访问, 密码123456；

```mysql
CREATE USER 'coisini'@'localhost' IDENTIFIED BY '123456';
```

② 创建用户 xiao , 可以在任意主机访问该数据库, 密码123456；

```mysql
CREATE USER 'xiao'@'%' IDENTIFIED BY '123456';
```

③ 修改用户 xiao 的访问密码为12345;

```mysql
-- MySQL8.0语法
ALTER USER 'xiao'@'%' IDENTIFIED WITH mysql_native_password BY '1234';
-- MySQL9.0语法
ALTER USER 'xiao'@'%' IDENTIFIED BY '1234';
```

④ 删除coisini@localhost 用户

```mysql
DROP USER 'coisini'@'localhost';
```

#### 2.6.2 权限控制

| 权限                | 说明               |
| ------------------- | ------------------ |
| ALL, ALL PRIVILEGES | 所有权限           |
| SELECT              | 查询数据           |
| INSERT              | 插入数据           |
| UPDATE              | 修改数据           |
| DELETE              | 删除数据           |
| ALTER               | 修改表             |
| DROP                | 删除数据库/表/视图 |
| CREATE              | 创建数据库/表      |

更多权限：[https://dev.mysql.com/doc/refman/8.4/en/privileges-provided.html](https://dev.mysql.com/doc/refman/8.4/en/privileges-provided.html)

- 查询权限

  ```mysql
  SHOW GRANTS FOR '用户名'@'主机名';
  ```

- 授予权限

  ```mysql
  GRANT 权限列表 ON 数据库名.表名 TO '用户名'@'主机名';
  ```

- 撤销权限

  ```mysql
  REVOKE 权限列表 ON 数据库名.表名 FROM '用户名'@'主机名';
  ```

> 多个权限使用, 使用逗号分隔
>
> 授权时，数据库名 和 表名 可以使用 * 进行通配，代表所有。

**相关案例：**

① 查询 'xiao'@'%'用户的权限

```mysql
SHOW GRANTS FOR 'xiao'@'%';
```

② 授予 'xiao'@'%' 用户 emps数据库 所有表 的所有操作权限

```mysql
GRANT ALL ON emps.* TO 'xiao'@'%';
```

③ 撤销 'xiao'@'%' 用户的 emps 数据库的所有权限

```mysql
REVOKE ALL ON emps.* FROM 'xiao'@'%';
```

## 3. 函数

>一段可以直接被另一段程序调用的程序或代码。在MySQL中已提供，我们在合适的业务场景调用对应的函数完成对应的业务需求即可。
>
>主要分为4类：字符串函数、数值函数、日期函数、流程函数

### 3.1 字符串函数

| 函数                     | 功能                                                      |
| ------------------------ | --------------------------------------------------------- |
| CONCAT(S1,S2,...Sn)      | 字符串拼接，将S1，S2，...Sn拼接成一个字符串               |
| LOWER(str)               | 将字符串str全部转为小写                                   |
| UPPER(str)               | 将字符串str全部转为大写                                   |
| LPAD(str,n,pad)          | 左填充，用字符串pad对str的左边进行填充，达到n个字符串长度 |
| RPAD(str,n,pad)          | 右填充，用字符串pad对str的右边进行填充，达到n个字符串长度 |
| TRIM(str)                | 去掉字符串头部和尾部的空格                                |
| SUBSTRING(str,start,len) | 返回从字符串str从start位置起的len个长度的字符串           |

**相关案例：**

① CANCAT: 字符串拼接

```mysql
SELECT CONCAT('HELLO','MySQL');
```

② LOWER: 全部转小写

```mysql
SELECT LOWER('Hello');
```

③ UPPER: 全部转大写

```mysql
SELECT UPPER('Hello');
```

④ LPAD: 左填充(---01)

```mysql
SELECT LPAD('01',5,'-');
```

⑤ RPAD: 右填充(01---)

```mysql
SELECT RPAD('01',5,'-');
```

⑥ TRIM: 去除空格

```mysql
SELECT TRIM(' 1 Hello MySQL 1');
```

⑦ SUBSTRING: 截取子字符串

```mysql
SELECT SUBSTRING('Hello MySQL',1,5);
```

- 工号统一为5位数，目前不足5位数的全部在前面补0。比如：1号员工工号应为00001

  ```mysql
  UPDATE emps SET workno = LPAD(workno,5,'0');
  SELECT workno FROM emps;
  ```

### 3.2 数值函数

| 函数       | 功能                               |
| ---------- | ---------------------------------- |
| CEIL(x)    | 向上取整                           |
| FLOOR(x)   | 向下取整                           |
| MOD(x,y)   | 返回x/y的模                        |
| RAND()     | 返回0~1内的随机数                  |
| ROUND(x,y) | 求参数x的四舍五入的值，保留y位小数 |

① CEIL: 向上取整

```mysql
SELECT CEIL(1.1);
```

② FLOOR: 向下取整

```mysql
SELECT FLOOR(1.9);
```

③ MOD: 取模

```mysql
SELECT MOD(7,4);
```

④ RAND: 获取随机数

```mysql
SELECT RAND();
```

⑤ ROUND: 四舍五入

```mysql
SELECT ROUND(2.344,2);
```

- 通过数据库的函数，生成一个六位数的随机验证码。

  >获取随机数可以通过rand()函数，但是获取出来的随机数是在0-1之间的，所以可以在其基础上乘以1000000，然后舍弃小数部分，如果长度不足6位，补0

  ```mysql
  SELECT LPAD(ROUND(RAND()*1000000, 0), 6, '0');
  ```

### 3.3 日期函数

| 函数                               | 功能                                              |
| ---------------------------------- | ------------------------------------------------- |
| CURDATE()                          | 返回当前日期                                      |
| CURTIME()                          | 返回当前时间                                      |
| NOW()                              | 返回当前日期和时间                                |
| YEAR(date)                         | 获取指定的date的年份                              |
| MONTH(date)                        | 获取指定的date的月份                              |
| DAY(date)                          | 获取指定的date的日期                              |
| DATE_ADD(date, INTERVAL expr type) | 返回一个日期/时间值加上一个时间间隔expr后的时间值 |
| DATEDIFF(date1,date2)              | 返回起始时间date1和结束时间date2之间的天数        |

```mysql
# CURDATE: 当前日期
SELECT CURDATE();

# CURTIME: 当前时间
SELECT CURTIME();

# NOW: 当前日期和时间
SELECT NOW();

# YEAR , MONTH , DAY: 当前年、月、日
SELECT YEAR(NOW());
SELECT MONTH(NOW());
SELECT DAY(NOW());

# DATE_ADD: 增加指定的时间间隔
SELECT DATE_ADD(NOW(),INTERVAL 70 YEAR);

# DATEDIFF: 获取两个日期相差的天数
SELECT DATEDIFF('2019-09-01','2024-09-26');
```

- 查询所有员工的入职天数，并根据入职天数倒序排序。

  > 入职天数，通过当前日期-入职日期，用datediff函数来完成。
  >
  > ```mysql
  > SELECT name, DATEDIFF(CURDATE(), entrydate) entryDay FROM emps ORDER BY entryDay DESC;
  > ```

### 3.4 流程函数

| 函数                                                         | 功能                                                       |
| ------------------------------------------------------------ | ---------------------------------------------------------- |
| IF(value , t , f)                                            | 如果value为true，则返回t，否则返回f                        |
| IFNULL(value1 , value2)                                      | 如果value1不为空，返回value1，否则返回value2               |
| CASE WHEN [ val1 ] THEN [res1] ... ELSE [ default ] END      | 如果val1为true，返回res1，... 否则返回default默认值        |
| CASE [ expr ] WHEN [ val1 ] THEN [res1] ... ELSE [ default ] END | 如果expr的值等于val1，返回 res1，... 否则返回default默认值 |

```mysql
# IF 如果value为true，则返回t，否则返回f
SELECT IF(FALSE, 'OK','ERROR');

# IFNULL 如果value1不为空，返回value1，否则返回value2
SELECT IFNULL('OK','DEFAULT');
SELECT IFNULL('','DEFAULT');
SELECT IFNULL(NULL,'DEFAULT');

# CASE WHEN THEN ELSE END
-- 查询emps表的员工姓名和工作地址（北京/上海 -》一线城市，其它 -》二线城市）
SELECT name, CASE workaddress WHEN '北京' THEN '一线城市' WHEN '上海' THEN '一线城市' ELSE '二线城市' END FROM emps;
```

**相关案例：**

> 数据准备

- ```mysql
  CREATE TABLE score(
         id int COMMENT 'ID',
         name varchar(20) COMMENT '姓名',
         math int COMMENT '数学',
         english int COMMENT '英语',
         chinese int COMMENT '语文'
     ) COMMENT '学员成绩表';
  INSERT INTO score(id, name, math, english, chinese) VALUES (1, 'Tom', 67, 88, 95), (2, 'Rose' , 23, 66, 90),(3, 'Jack', 56, 98, 76);
  ```

- 分数 >=85 优秀，>=60 及格，其它不及格

  ```mysql
  SELECT name, 
  (CASE WHEN math >= 85 THEN '优秀' WHEN math >= 60 THEN '及格' ELSE '不及格' END) '数学',
  (CASE WHEN english >= 85 THEN '优秀' WHEN english >= 60 THEN '及格' ELSE '不及格' END) '英语',
  (CASE WHEN chinese >= 85 THEN '优秀' WHEN chinese >= 60 THEN '及格' ELSE '不及格' END) '语文'
  FROM score;
  ```

- 数据库中，存储的是入职日期，如2000-01-01，快速计算出入职天数

  > DATEDIFF
  >
  > ```mysql
  > SELECT `name`, DATEDIFF(CURDATE(), entrydate) FROM emps;
  > ```

- 数据库中，存储的是学生的分数值，如98、75，快速判定分数的等级

  > CASE ... WHEN ...
  >
  > ```mysql
  > SELECT name, 
  > (CASE WHEN math >= 98 THEN '优秀' WHEN math >= 75 THEN '及格' ELSE '良好' END) '数学',
  > (CASE WHEN english >= 98 THEN '优秀' WHEN english >= 75 THEN '及格' ELSE '良好' END) '英语',
  > (CASE WHEN chinese >= 98 THEN '优秀' WHEN chinese >= 75 THEN '及格' ELSE '良好' END) '语文'
  > FROM score;
  > ```

## 4. 约束

> 概念：作用于表中字段上的规则，用于限制存储在表中的数据。
>
> 目的：保证数据库中数据的正确、有效性和完整性。
>
> 分类：

| 约束                   | 描述                                                     | 关键字      |
| ---------------------- | -------------------------------------------------------- | ----------- |
| 非空约束               | 限制该字段数据不为NULL                                   | NOT NULL    |
| 唯一约束               | 保证该字段所有数据都是唯一、不重复的                     | UNIQUE      |
| 主键约束               | 主键是一行数据的唯一标识，要求非空唯一                   | PRIMARY KEY |
| 默认约束               | 保存数据时，如果未指定该字段的值，则采用默认值           | DEFAULT     |
| 检查约束（8.0.16版本） | 保证字段值满足某一个条件                                 | CHECK       |
| 外键约束               | 用来让两张表的数据之间建立连接，保证数据的一致性和完整性 | FOREIGN KEY |

### 4.1 常见约束

| 字段名 | 字段含义   | 字段类型    | 约束条件                  | 约束关键字                 |
| ------ | ---------- | ----------- | ------------------------- | -------------------------- |
| id     | ID唯一标识 | int         | 主键，自动增长            | PRIMARY KEY,AUTO_INCREMENT |
| name   | 姓名       | varchar(10) | 不为空，并且唯一          | NOT NULL , UNIQUE          |
| age    | 年龄       | int         | 大于0，并且小于等于120    | CHECK                      |
| status | 状态       | char(1)     | 如果没有指定该值，默认为1 | DEFAULT                    |
| gender | 性别       | char(1)     |                           |                            |

对应建表语句：

```mysql
CREATE TABLE tb_user(
	id int AUTO_INCREMENT PRIMARY KEY COMMENT 'id主键',
    name VARCHAR(10) NOT NULL UNIQUE COMMENT '姓名',
    age int CHECK(age > 0 && age <= 120) COMMENT '年龄',
    status CHAR(1) DEFAULT '1' COMMENT '状态',
    gender CHAR(1) COMMENT '性别'
) COMMENT '用户表';
```

添加数据：(测试约束的有效性)

```mysql
INSERT INTO tb_user(name,age,status,gender) VALUES ('Tom1',19,'1','男'), ('Tom2',25,'0','男');
INSERT INTO tb_user(name,age,status,gender) VALUES ('Tom3',19,'1','男');
INSERT INTO tb_user(name,age,status,gender) VALUES (null,19,'1','男');
INSERT INTO tb_user(name,age,status,gender) VALUES ('Tom3',19,'1','男');
INSERT INTO tb_user(name,age,status,gender) VALUES ('Tom4',80,'1','男');
INSERT INTO tb_user(name,age,status,gender) VALUES ('Tom5',-1,'1','男');
INSERT INTO tb_user(name,age,status,gender) VALUES ('Tom5',121,'1','男');
INSERT INTO tb_user(name,age,gender) VALUES ('Tom5',120,'男');
```

### 4.2 外键约束

> 外键：用来让两张表的数据之间建立连接，从而保证数据一致性和完整性。
>
> 例如：A表中存有B表的id字段值，如果需要查询B表数据。需要关联起来，
>
> 但只是在逻辑上存在这样一层关系。在数据库层面，并未建立外键关联， 
> 所以是无法保证数据的一致性和完整性的。

数据准备：

```mysql
CREATE TABLE dept(
    id  int auto_increment primary key COMMENT 'ID',
    name varchar(50) not null COMMENT '部门名称'
  )COMMENT '部门表';
  
INSERT INTO dept (id, name) VALUES (1, '研发部'), (2, '市场部'),(3, '财务部'), (4, '销售部'), (5, '总经办');

CREATE TABLE emp(
      id  int auto_increment primary key COMMENT 'ID',
      name varchar(50) not null COMMENT '姓名',
      age int COMMENT '年龄',
      job varchar(20) COMMENT '职位',
      salary int COMMENT '薪资',
      entrydate date COMMENT '入职时间',
      managerid int COMMENT '直属领导ID',
      dept_id int COMMENT '部门ID'
)COMMENT '员工表';

INSERT INTO emp (id, name, age, job,salary, entrydate, managerid, dept_id) VALUES (1, '金庸', 66, '总裁',20000, '2000-01-01', null,5),(2, '张无忌', 20,'项目经理',12500, '2005-12-05', 1,1),(3, '杨逍', 33, '开发', 8400,'2000-11-03', 2,1),(4, '韦一笑', 48, '开发',11000, '2002-02-05', 2,1),(5, '常遇春', 43, '开发',10500, '2004-09-07', 3,1),(6, '小昭', 19, '程序员鼓励师',6600, '2004-10-12', 2,1);
```

> 此时删除id为1的部门信息，部门表不存在id为1的部门，而在emp表中还有很多的员工关联的为id为1的部门，此时就出现了数据的不完整性。
>
> ``` mysql
> SELECT * FROM emp;
> SELECT * FROM dept;
> # 尝试删除id为1的部门信息
> DELETE FROM dept WHERE id = 1;
> ```
>
> 解决： 创建数据库外键约束。

#### 4.2.1 语法

① 添加外键

```mysql
CREATE TABLE 表名(
	字段名 数据类型,
    ...
    [CONSTRAINT] [外键名称] FOREIGN KEY (外键字段名) REFERENCES 主表(主表列名)
);
```

```mysql
ALTER TABLE 表名 ADD CONSTRAINT 外键名称 FOREIGN KEY (外键字段名) REFERENCES 主表 (主表列名);
```

**相关案例：**

- 为emp表的dept_id字段添加外键约束,关联dept表的主键id。

  ```mysql
  ALTER TABLE emp ADD CONSTRAINT fk_emp_dept_id FOREIGN KEY (dept_id)REFERENCES dept(id);
  
  # 尝试删除id为1的部门信息
  DELETE FROM dept WHERE id = 1;
  ```

② 删除外键

```mysql
ALTER TABLE 表名 DROP FOREIGN KEY 外键名称
```

- 删除emp表的外键fk_emp_dept_id

  ```mysql
  ALTER TABLE emp DROP FOREIGN KEY fk_emp_dept_id;
  ```

#### 4.2.2 删除/更新行为

>添加了外键之后，再删除父表数据时产生的约束行为，称为删除/更新行为。具体有以下几种:

| 行为        | 说明                                                         |
| ----------- | ------------------------------------------------------------ |
| NO ACTION   | 当在父表中删除/更新对应记录时，首先检查该记录是否有对应外键，如果有则不允许删除/更新。 (与 RESTRICT 一致) 默认行为 |
| RESTRICT    | 当在父表中删除/更新对应记录时，首先检查该记录是否有对应外键，如果有则不允许删除/更新。 (与 NO ACTION 一致) 默认行为 |
| CASCADE     | 当在父表中删除/更新对应记录时，首先检查该记录是否有对应外键，如果有，则也删除/更新外键在子表中的记录。 |
| SET NULL    | 当在父表中删除对应记录时，首先检查该记录是否有对应外键，如果有则设置子表中该外键值为null（这就要求该外键允许取null）。 |
| SET DEFAULT | 父表有变更时，子表将外键列设置成一个默认的值 (Innodb不支持)  |

语法：

```mysql
ALTER TABLE 表名 ADD CONSTRAINT 外键名称 FOREIGN KEY (外键字段) REFERENCES 主表名 (主表字段名) ON UPDATE CASCADE ON DELETE CASCADE;
```

- CASCADE级联

  ```mysql
  ALTER TABLE emp ADD CONSTRAINT fk_emp_dept_id FOREIGN KEY (dept_id) REFERENCES dept(id) ON UPDATE CASCADE ON DELETE CASCADE;
  
  # 父表id为1的值修改为6
  UPDATE dept  SET id = '6' WHERE id = '1';
  
  # 此时查询emp，dept_id会级联修改
  SELECT * FROM emp;
  ```

  > 但是如果删除操作，emp对应表数据也会级联删除

- SET NULL 

  > ```mysql
  > ALTER TABLE emp ADD CONSTRAINT fk_emp_dept_id FOREIGN KEY (dept_id) REFERENCES dept(id) ON UPDATE SET null ON DELETE SET null ;
  > ```

此时删除id为6的部门数据

```mysql
DELETE FROM dept WHERE id = '6';

# 此时查询emp，dept_id会联动修改为NULL
SELECT * FROM emp;
```

## 5. 多表查询

### 5.1 多表关系

> 在项目开发中数据库表结构设计时，会根据业务需求及业务模块之间的关系。分析并设计表结构，由于业务之间相互关联。所以各个表结构之间也存在着各种联系，基本上分为三种：
>
> - 一对多(多对一) 
>
> - 多对多
>
> - 一对一

#### 5.1.1 一对多

部门与员工的关系

#### 5.1.2 多对多

学生表(student)id、课程表(course)id、学生课程关系表(student_course)

```mysql
CREATE TABLE student(
			id int AUTO_INCREMENT PRIMARY KEY COMMENT '主键ID',
      name varchar(10) COMMENT '姓名',
      NO varchar(10) COMMENT '学号'
   ) COMMENT '学生表';

INSERT INTO student VALUES (null,'黛绮丝', '2000100101'),(null,'谢逊', '2000100102'),(null, '殷天正', '2000100103'),(null,'韦一笑','2000100104');

CREATE TABLE course(
	id int AUTO_INCREMENT PRIMARY KEY COMMENT '主键ID',
	name varchar(10) COMMENT '课程名称'
   ) COMMENT '课程表';
   
INSERT INTO course values (null, 'Java'), (null, 'PHP'), (null , 'MySQL'), (null, 'Hadoop');

CREATE TABLE student_course(
    id int AUTO_INCREMENT PRIMARY KEY COMMENT '主键ID',
    studentid int NOT null COMMENT '学生ID',
    courseid int NOT null COMMENT '课程ID',
    CONSTRAINT fk_courseid FOREIGN KEY (courseid) REFERENCES course (id),
    CONSTRAINT fk_studentid FOREIGN KEY (studentid) REFERENCES student (id)
   )COMMENT '学生课程中间表';

INSERT INTO student_course VALUES (null,1,1),(null,1,2),(null,1,3),(null,2,2), (null,2,3),(null,3,4);
```

#### 5.1.3 一对一

> - 用户和用户详情关系
>
> - 关系: 一对一关系，多用于单表拆分，将一张表的基础字段放在一张表中，其他详情字段放在另 一张表中，以提升操作效率
>
> - 实现: 在任意一方加入外键，关联另外一方的主键，并且设置外键为唯一的(UNIQUE)

```mysql
CREATE TABLE tb_users(
 id int AUTO_INCREMENT PRIMARY KEY COMMENT '主键ID',
 name varchar(10) COMMENT '姓名',
 age int COMMENT '年龄',
 gender char(1) COMMENT '1: 男 , 2: 女',
 phone char(11) COMMENT '手机号'
) COMMENT '用户基本信息表';

CREATE TABLE tb_users_edu(
 	id int AUTO_INCREMENT PRIMARY KEY COMMENT '主键ID',
    degree varchar(20) COMMENT '学历',
    major varchar(50) COMMENT '专业',
    primaryschool varchar(50) COMMENT '小学',
    middleschool varchar(50) COMMENT '中学',
    university varchar(50) COMMENT '大学',
    userid int UNIQUE COMMENT '用户ID',
    CONSTRAINT fk_userid FOREIGN KEY (userid) REFERENCES tb_users(id)
) COMMENT '用户教育信息表';

INSERT INTO tb_users(id, name, age, gender, phone) values (null,'黄渤',45,'1','18800001111'),(null,'冰冰',35,'2','18800002222'),(null,'码云',55,'1','18800008888'),(null,'李彦宏',50,'1','18800009999');

INSERT INTO tb_users_edu(id, degree, major, primaryschool, middleschool, university, userid) VALUES (null,'本科','舞蹈','静安区第一小学','静安区第一中学','北京舞蹈学院',1),(null,'硕士','表演','朝阳区第一小学','朝阳区第一中学','北京电影学院',2),(null,'本科','英语','杭州市第一小学','杭州市第一中学','杭州师范大学',3),(null,'本科','应用数学','阳泉第一小学','阳泉区第一中学','清华大学',4);
```

### 5.2 多表查询

> 数据准备

```mysql
--- 删除之前emp,dept表测试数据
DROP TABLE IF EXISTS emp;
DROP TABLE IF EXISTS dept;

-- 创建emp,dept表并添加测试数据
CREATE TABLE dept(
	id int AUTO_INCREMENT PRIMARY KEY COMMENT 'ID主键',
    name VARCHAR(50) NOT NULL COMMENT '部门名称'
) COMMENT '部门表';

INSERT INTO dept(id, name)VALUES(1,'研发部'),(2,'市场部'),(3,'财务部'),(4,'销售部'),(5,'总经办'),(6,'人事部');

CREATE TABLE emp(
	id int AUTO_INCREMENT PRIMARY KEY COMMENT 'ID主键',
    name VARCHAR(50)NOT NULL COMMENT '姓名',
    age int COMMENT '年龄',
    job VARCHAR(20) COMMENT '职位',
    salary int COMMENT '薪资',
    entrydate date COMMENT '入职时间',
    managerid int COMMENT '直属领导ID',
    dept_id int COMMENT '部门ID'
) COMMENT '员工表';

-- 添加外键
ALTER TABLE emp ADD CONSTRAINT fk_emp_dept_id FOREIGN KEY (dept_id) REFERENCES dept(id);

INSERT INTO emp (id, name, age, job,salary, entrydate, managerid, dept_id) VALUES
(1, '金庸', 66, '总裁',20000, '2000-01-01', null,5),
(2, '张无忌', 20, '项目经理',12500, '2005-12-05', 1,1),
(3, '杨逍', 33, '开发', 8400,'2000-11-03', 2,1),
(4, '韦一笑', 48, '开发',11000, '2002-02-05', 2,1),
(5, '常遇春', 43, '开发',10500, '2004-09-07', 3,1),
(6, '小昭', 19, '程序员鼓励师',6600, '2004-10-12', 2,1),
(7, '灭绝', 60, '财务总监',8500, '2002-09-12', 1,3),
(8, '周芷若', 19, '会计',48000, '2006-06-02', 7,3),
(9, '丁敏君', 23, '出纳',5250, '2009-05-13', 7,3),
(10, '赵敏', 20, '市场部总监',12500, '2004-10-12', 1,2),
(11, '鹿杖客', 56, '职员',3750, '2006-10-03', 10,2),
(12, '鹤笔翁', 19, '职员',3750, '2007-05-09', 10,2),
(13, '方东白', 19, '职员',5500, '2009-02-12', 10,2),
(14, '张三丰', 88, '销售总监',14000, '2004-10-12', 1,4),
(15, '俞莲舟', 38, '销售',4600, '2004-10-12', 14,4),
(16, '宋远桥', 40, '销售',4600, '2004-10-12', 14,4),
(17, '陈友谅', 42, null,2000, '2011-10-12', 1,null);
```

#### 5.2.1 概述

> 从多张表查询数据
>
> 例如：SELECT *  FROM emp,dept WHERE emp.dept_id = dept.id;

如果不添加条件，会查出102条记录，这是员工表emp所有的记录 
(17) 与 部门表dept所有记录(6) 的所有组合情况，称之为笛卡尔积。
笛卡尔积: 数学中两个集合A集合和B集合的所有组合情况

#### 5.2.2 分类

- 连接查询

  - 内连接：相当于查询A、B交集部分数据 
  - 外连接：
  - 左外连接：查询左表所有数据，以及两张表交集部分数据 
  - 右外连接：查询右表所有数据，以及两张表交集部分数据 
  - 自连接：当前表与自身的连接查询，自连接必须使用表别名

- 子查询

  查询语句嵌套在另一个查询语句内部的查询

### 5.3 内连接

> 内连接查询的是两张表交集部分数据

内连接的语法分为两种：隐式内连接、显示内连接

#### 5.3.1 隐式内连接

```mysql
SELECT 字段列表 FROM 表1, 表2 WHERE 条件 ...;
```

#### 5.3.2 显式内连接

```mysql
SELECT 字段列表 FROM 表1 [INNER] JOIN 表2 ON 连接条件 ...;
```

**相关案例：**

> 查询每一个员工的姓名，及关联的部门的名称（隐式内连接实现）
>
> 表结构：emp, dept
>
> 连接条件：emp.dept_id = dept.id

```mysql
SELECT emp.name, dept.name FROM emp, dept WHERE emp.dept_id = dept.id;

-- 简写
select e.name,d.name from emp e , dept d where e.dept_id = d.id;
```

> 查询每一个员工的姓名，及关联的部门的名称（显示内连接实现）INNER JON
>
> 表结构：emp, dept
>
> 连接条件：emp.dept_id = dept.id

```mysql
SELECT e.name, d.name FROM emp e INNER JOIN dept d ON e.dept_id = d.id;

-- 简写
SELECT e.name, d.name FROM emp e JOIN dept d ON e.dept_id = d.id;
```

### 5.4 外连接

>左外连接、右外连接

#### 5.4.1 左外连接

```mysql
SELECT 字段列表 FROM 表1 LEFT [OUTER] JOIN 表2 ON 条件...;
```

左外连接相当于查询表1(左表)所有数据，也包含表1和表2交集部分的数据

#### 5.4.2 右外连接

```mysql
SELECT 字段列表 FROM 表1 RIGHT [OUTER] JOIN 表2 ON 条件...;
```

右外连接相当于查询表2(右表)所有数据，也包含表1和表2交集部分的数据。

**相关案例：**

> 查询emp表的所有数据, 和对应的部门信息。（使用左外连接查询）
>
> 表结构：emp, dept
>
> 连接条件：emp.dept_id = dept.id

```mysql
SELECT e.*, d.name FROM emp e LEFT OUTER JOIN dept d ON e.dept_id = d.id;

-- 简写
SELECT e.*, d.name FROM emp e LEFT JOIN dept d ON e.dept_id = d.id;
```

> 查询dept表所有数据，和对应的员工信息（使用外连接查询）
>
> 表结构：emp, dept
>
> 连接条件：emp.dept_id = dept.id

```mysql
-- 右外连接
SELECT d.*, e.* FROM emp e RIGHT OUTER JOIN dept d ON e.dept_id = d.id;

-- 左外连接
SELECT d.*, e.* FROM dept d LEFT OUTER JOIN emp e ON e.dept_id = d.id;
```

> **左外连接和右外连接 可以相互替换，只需调整在连接查询时SQL中,表结构的先后顺序。在日常开发使用时，更偏向于左外连接。**

### 5.5 自连接

#### 5.5.1 自连接查询

> 自己连接自己，一张表连接查询多次。

语法：

```mysql
SELECT 字段列表 FROM 表A 别名A JOIN 表A 别名B ON 条件...;
```

自连接可以是内连接查询，也可以是外连接查询。

**相关案例：**

> 查询员工 及其领导的名字
>
> 表结构：emp

```mysql
SELECT a.name, b.name FROM emp a , emp b WHERE a.managerid = b.id;

SELECT a.name, b.name FROM emp a JOIN emp b ON a.managerid = b.id;
```

>查询所有员工 emp 及其领导的名字 emp , 如果员工没有领导, 也需查询出来
>表结构: emp a , emp b

```mysql
SELECT a.name '员工', b.name '领导' FROM emp a LEFT JOIN emp b ON a.managerid = b.id;
```

> 在自连接查询中，必须要为表起别名，要不然我们不清楚所指定的条件、返回的字段，到底是哪一张表的字段。

#### 5.5.2 联合查询

> 对于union查询，就是把多次查询的结果合并起来，形成一个新的查询结果集。

```mysql
SELECT 字段列表 FROM 表A ...
UNION [ALL]
SELECT 字段列表 FROM 表B ...;
```

- 对于联合查询的多张表的列数必须保持一致，字段类型也需要保持一致。
- UNION ALL 会将全部的数据直接合并在一起，UNION会对合并之后的数据去重

**相关案例：**

- 将薪资低于5000的员工，和 年龄大于50岁的员工查询出来。

  > UNION ALL 仅仅简单合并，未去重

  ```mysql
  SELECT * FROM emp WHERE salary < 5000 UNION ALL SELECT * FROM emp  WHERE age > 50;
  ```

  > UNION 可去重

  ```mysql
  SELECT * FROM emp WHERE salary < 5000 UNION SELECT * FROM emp  WHERE age > 50;
  ```

  >如果多条查询语句查询出来的结果，字段数量不一致，在进行union/union all联合查询时，将会报错。
  >
  >例如：
  >
  >SELECT * FROM emp WHERE salary < 5000 UNION SELECT name FROM emp  WHERE age > 50;
  >
  >报错如下：
  >
  >1222 - The used SELECT statements have a different number of columns

### 5.6 子查询

#### 5.6.1 概述

> SQL语句中嵌套SELECT语句，称为嵌套查询，又称子查询
>
> ```mysql
> SELECT * FROM t1 WHERE columnl = (SELECT columnl FROM t2);
> ```
>
> 子查询外部的语句可以是INSERT / UPDATE / DELETE / SELECT 的任何一个。

分类：

根据子查询结果不同：

- 标量子查询（子查询结果为单个值）
- 列子查询（子查询结果为一列）
- 行子查询（子查询结果为一行）
- 表子查询（子查询结果为多行多列）

根据子查询位置：

- WHERE之后
- FROM之后
- SELECT之后

#### 5.6.2 标量子查询

> 子查询返回的结果是单个值（数字、字符串、日期等），最简单的形式，这种子查询称为标量子查询。 
> 常用的操作符：=  <>  >   >=   <  <=

**相关案例：**

- 查询“销售部”所有员工信息

  需求分解：

  - 查询“销售部”部门ID

    ```mysql
    SELECT id FROM dept WHERE name = '销售部';
    ```

  - 根据“销售部”部分ID，查询员工信息

    ```mysql
    SELECT * FROM emp WHERE dept_id = (SELECT id FROM dept WHERE name = '销售部');
    ```

- 查询在“方东白”入职之后的员工信息

  需求分析：

  - 查询 东方白 的入职日期

    ```mysql
    SELECT entrydate FROM empt WHERE name = '方东白';
    ```

  - 查询指定入职日期之后入职的员工信息

    ```mysql
    SELECT * FROM emp WHERE entrydate > (SELECT entrydate FROM emp WHERE name = '方东白');
    ```

#### 5.6.3 列子查询

> 子查询返回的结果是一列（可以是多行），这种子查询称为列子查询。
>
> 常用的操作符：IN、NOT IN、ANY、SOME、ALL

| 操作符 | 描述                                   |
| ------ | -------------------------------------- |
| IN     | 在指定的集合范围之内，多选一           |
| NOT IN | 不在指定的集合范围之内                 |
| ANY    | 子查询返回列表中，有任意一个满足即可   |
| SOME   | 与ANY等同，使用SOME的地方都可以使用ANY |
| ALL    | 子查询返回列表的所有值都必须满足       |

**相关案例：**

- 查询“销售部” 和 “市场部” 的所有员工信息

  需求分析：

  - 查询 “销售部” 和 “市场部” 的部门ID

    SELECT id FROM dept WHERE name = '销售部' OR name = '市场部';

  - 根据部门ID, 查询员工信息

    ```mysql
    SELECT * FROM emp WHERE dept_id IN (SELECT id FROM dept WHERE name = '销售部' OR name = '市场部');
    ```

- 查询比财务部所有人工资都高的信息

  需求分析：

  ```mysql
  -- 查询 财务部 用户id
  SELECT id FROM dept WHERE name = '财务部';
  
  -- 查询 财务部用户工资
  SELECT salary FROM emp WHERE dept_id = (SELECT id FROM dept WHERE name = '财务部');
  
  -- 查询比财务部所有人工资都高的信息
  SELECT * FROM emp WHERE salary > ALL (SELECT salary FROM emp WHERE dept_id = (SELECT id FROM dept WHERE name = '财务部'));
  ```

  

- 查询比研发部其中任意一人工资高的员工信息

  需求分析：

  ```mysql
  -- 查询研发部所有人工资
  SELECT salary FROM emp WHERE dept_id = (SELECT id FROM dept WHERE name = '研发部');
  
  -- 比研发部其中任意一人工资高的员工信息
  SELECT * FROM emp WHERE salary > ANY(SELECT salary FROM emp WHERE dept_id = (SELECT id FROM dept WHERE name = '研发部'));
  ```

#### 5.6.4 行子查询

> 子查询返回的结果是一行（可以是多列），这种子查询称为行子查询。
>
> 常用的操作符：= 、<> 、IN 、NOT IN

**相关案例：**

- 查询与“张无忌”的薪资及直属领导相同的员工信息

  需求分析：

  ```mysql
  -- 查询“张无忌”的薪资及直属领导
  SELECT salary,managerid FROM emp WHERE name = '张无忌';
  
  -- 查询与"张无忌" 的薪资及直属领导相同的员工信息
  SELECT * FROM emp WHERE (salary,managerid) = (SELECT salary,managerid FROM emp WHERE name = '张无忌');
  ```

#### 5.6.5 表子查询

> 子查询返回的结果是多行多列，这种子查询称为表子查询。
>
> 常用的操作符：IN

**相关案例：**

- 查询与"鹿杖客", "宋远桥"的职位和薪资相同的员工信息。

  需求分析：

  ```mysql
  -- 查询"鹿杖客", "宋远桥" 的职位和薪资
  SELECT job,salary FROM emp WHERE name = '鹿杖客' OR name = '宋远桥';
  
  -- 查询与"鹿杖客", "宋远桥" 的职位和薪资相同的员工信息
  SELECT * FROM emp WHERE (job,salary) IN (SELECT job,salary FROM emp WHERE name = '鹿杖客' OR name = '宋远桥');
  ```

- 查询入职日期“2006-01-01”之后的员工信息，及其部分信息

  需求分析：

  ```msyql
  -- 入职日期是"2006-01-01" 之后的员工信息
  SELECT * FROM emp WHERE entrydate > '2006-01-01';
  
  -- 查询这部分员工, 对应的部门信息;
  SELECT e.*, d.* FROM (SELECT * FROM emp WHERE entrydate > '2006-01-01') e LEFT JOIN dept d ON e.dept_id = d.id;
  ```

### 5.7 多表查询案例

> 数据准备

```mysql
CREATE TABLE salgrade(
    grade int,
    losal int,
    hisal int
) COMMENT '薪资等级表';

INSERT INTO salgrade VALUES (1,0,3000);
INSERT INTO salgrade VALUES (2,3001,5000);
INSERT INTO salgrade VALUES (3,5001,8000);
INSERT INTO salgrade VALUES (4,8001,10000);
INSERT INTO salgrade VALUES (5,10001,15000);
INSERT INTO salgrade VALUES (6,15001,20000);
INSERT INTO salgrade VALUES (7,20001,25000);
INSERT INTO salgrade VALUES (8,25001,30000);
```

> 涉及表：emp员工表、dept部门表、salgrade薪资等级表

- 查询员工的姓名、年龄、职位、部门信息（隐式内连接） 
  表: emp, dept
  连接条件: emp.dept_id = dept.id

  ```mysql
  SELECT e.name '姓名',e.age '年龄', e.job '职位', d.name '部门信息'
  FROM emp e, dept d 
  WHERE e.dept_id = d.id;
  ```

- 查询年龄小于30岁的员工的姓名、年龄、职位、部门信息（显式内连接） 
  表: emp , dept
  连接条件: emp.dept_id = dept.id

  ```mysql
  SELECT e.name '姓名',e.age '年龄', e.job '职位', d.name '部门信息'
  FROM emp e INNER JOIN dept d ON e.dept_id = d.id WHERE age < 30;
  ```

- 查询拥有员工的部门ID、部门名称 
  表: emp , dept
  连接条件: emp.dept_id = dept.id

  ```mysql
  SELECT DISTINCT d.id, d.name
  FROM emp e, dept d
  WHERE e.dept_id = d.id;
  ```

- 查询所有年龄大于40岁的员工, 及其归属的部门名称; 如果员工没有分配部门, 也需要展示出来(外连接)
  表: emp , dept
  连接条件: emp.dept_id = dept.id

  ```mysql
  SELECT e.*,d.name
  FROM emp e
  LEFT JOIN dept d ON e.dept_id = d.id WHERE e.age > 40;
  ```

- 查询所有员工的工资等级 
  表: emp , salgrade
  连接条件 : emp.salary >= salgrade.losal and emp.salary <= salgrade.hisal

  ```mysql
  SELECT e.*, s.grade, s.losal, s.hisal
  FROM emp e, salgrade s
  WHERE e.salary >= s.losal and e.salary <= s.hisal;
  --
  SELECT e.*, s.grade, s.losal, s.hisal
  FROM emp e, salgrade s
  WHERE e.salary BETWEEN s.losal AND s.hisal;
  ```

- 查询"研发部" 所有员工的信息及工资等级表: emp, salgrade, dept
  连接条件: emp.salary between salgrade.losal and salgrade.hisal, emp.dept_id = dept.id
  查询条件: dept.name = '研发部'

  ```mysql
  SELECT e.*, s.grade
  FROM emp e, salgrade s, dept d
  WHERE e.dept_id = d.id AND (e.salary BETWEEN s.losal AND s.hisal) AND
  d.name = '研发部';
  ```

- 查询"研发部" 员工的平均工资 
  表: emp , dept
  连接条件 : emp.dept_id = dept.id

  ```mysql
  SELECT AVG(e.salary)
  FROM emp e, dept d
  WHERE e.dept_id = d.id AND d.name = '研发部';
  ```

- 查询工资比"灭绝" 高的员工信息。 

  ```mysql
  -- ① 查询"灭绝" 的薪资
  SELECT salary
  FROM emp
  WHERE name = '灭绝';
  -- ② 查询比她工资高的员工数据
  SELECT *
  FROM emp
  WHERE salary > (SELECT salary FROM emp WHERE name = '灭绝');
  ```

- 查询比平均薪资高的员工信息 
  ```mysq
  -- ① 查询员工的平均薪资
  SELECT AVG(salary) FROM emp;
  -- ② 查询比平均薪资高的员工信息
  SELECT e.*
  FROM emp e
  WHERE salary > (SELECT AVG(salary) FROM emp);
  ```

- 查询低于本部门平均工资的员工信息 

  ```mysql
  -- ① 查询指定部门平均薪资
  SELECT AVG(salary) FROM emp e WHERE e.dept_id = 1;
  SELECT AVG(salary) FROM emp e WHERE e.dept_id = 2;
  -- ② 查询低于本部门平均工资的员工信息
  SELECT *
  FROM emp e2
  WHERE e2.salary < (SELECT AVG(salary) FROM emp e1 WHERE e1.dept_id = e2.dept_id);
  ```

- 查询所有的部门信息, 并统计部门的员工人数

  ```mysql
  SELECT d.id, d.name, (SELECT COUNT(*) FROM emp e WHERE e.dept_id = d.id) '人数'
  FROM dept d;
  ```

- 查询所有学生的选课情况, 展示出学生名称, 学号, 课程名称 
  表: student, course, student_course
  连接条件: student.id = student_course.studentid, course.id = student_course.courseid

  ```mysql
  SELECT s.name, s.NO, c.name
  FROM student s, course c, student_course sc
  WHERE s.id = sc.studentid
  AND	c.id = sc.courseid;
  ```

## 6. 事务

### 6.1 简介

> 一组操作的集合，一个不可分割的工作单位，事务会把所有的操作作为一个整体一起向系统提交或撤销操作请求，即这些操作要么同时成功，要么同时失败。
>
> 比如：
>
> - 张三给李四转账1000块钱，张三银行账户的钱减少1000，而李四银行账户的钱要增加1000。这一组操作就必须在一个事务的范围内，要么都成功，要么都失败。
>
> - 异常情况:  转账这个操作, 也是分为以下这么三步来完成, 在执行第三步是报错了, 这样就导致张三减少1000块钱, 而李四的金额没变, 这样就造成了数据的不一致, 就出现问题了。
>
> - 为了解决上述的问题，就需要通过数据的事务来完成，我们只需要在业务逻辑执行之前开启事务，执行完毕后提交事务。如果执行过程中报错，则回滚事务，把数据恢复到事务开始之前的状态。
>   - 默认MySQL的事务是自动提交的，也就是说，当执行完一条DML语句时，MySQL会立即隐式的提交事务。

### 6.2 事务操作

```mysql
-- 数据准备
DROP TABLE IF EXISTS account;

CREATE TABLE account(
	id int PRIMARY KEY AUTO_INCREMENT COMMENT 'ID主键',
    name VARCHAR(10) COMMENT '姓名',
    money DOUBLE(10,2) COMMENT '余额'
) COMMENT '账户表';

INSERT INTO account(name,money) VALUES ('张三',2000),('李四', 2000);
```

#### 6.2.1 未控制事务

- 正常操作

  ```mysql
  # 正常操作
  -- 1. 查询张三余额
  SELECT * FROM account WHERE name = '张三';
  -- 2. 张三的余额减少1000
  UPDATE account SET money = money - 1000 WHERE name = '张三';
  -- 3. 李四的余额增加1000
  UPDATE account SET money = money + 1000 WHERE name = '李四';
  ```

- 异常情况

  ```mysql
  -- 1. 查询张三余额
  SELECT * FROM account WHERE name = '张三';
  -- 2. 张三的余额减少1000
  UPDATE account SET money = money - 1000 where name = '张三';
   出错了....
   -- 3. 李四的余额增加1000
  UPDATE account SET money = money + 1000 where name = '李四';
  ```

  > 出现数据不一致情况

#### 6.2.2 控制事务一

- 查看/设置事务提交方式

  ```mysql
  SELECT @@autocommit;
  SET @@autocommit = 0;
  ```

- 提交事务

  ```mysql
  COMMIT;
  ```

- 回滚事务

  ```mysql
  ROLLBACK;
  ```

  >上述方式，修改了事务的自动提交行为, 把默认自动提交修改为了手动提交, 此时执行DML语句都不会提交, 需要手动执行commit提交。

#### 6.2.3 控制事务二

- 开启事务

  ```mysql
  START TRANSACTION 或 BEGIN ;
  ```

- 提交事务

  ```mysql
  COMMIT;
  ```

- 回滚事务

  ```mysql
  ROLLBACK;
  ```

**转账案例：**

```mysql
-- 开启事务
START TRANSACTION
-- 1. 查询张三余额
SELECT * FROM account WHERE name = '张三';
-- 2. 张三的余额减少1000
UPDATE account SET money = money - 1000 WHERE name = '张三';
-- 3. 李四的余额增加1000
UPDATE account SET money = money + 1000 WHERE name = '李四';
-- 如果正常执行完毕, 则提交事务
COMMIT;
-- 如果执行过程中报错, 则回滚事务
-- ROLLBACK;
```

### 6.3 事务四大特性

- 原子性（Atomicity）：事务是不可分割的最小操作单元，要么全部成功，要么全部失败。 

- 一致性（Consistency）：事务完成时，必须使所有的数据都保持一致状态。

- 隔离性（Isolation）：数据库系统提供的隔离机制，保证事务在不受外部并发操作影响的独立环境下运行。

- 持久性（Durability）：事务一旦提交或回滚，它对数据库中的数据的改变就是永久的。 

上述就是事务的四大特性，简称ACID。

### 6.4 并发事务问题

- 赃读：一个事务读到另外一个事务还没有提交的数据
- 不可重复读：一个事务先后读取同一条记录，但两次读取的数据不同，称之为不可重复读。
- 幻读：一个事务按照条件查询数据时，没有对应的数据行，但是在插入数据时，又发现这行数据已经存在，好像出现了"幻影"。

### 6.5 事务隔离级别

为解决并发事务所引发的问题，数据库中引入事务隔离级别。

主要有以下几种：

| 隔离级别              | 脏读 | 不可重复读 | 幻读 |
| --------------------- | ---- | ---------- | ---- |
| READ UNCOMMITTED      | √    | √          | √    |
| READ COMMITTED        | ×    | √          | √    |
| REPEATABLE READ(默认) | ×    | ×          | √    |
| SERIALIZABLE          | ×    | ×          | ×    |

- 查看事务隔离级别

  ```mysql
  SELECT @@TRANSACTION_ISOLATION;
  ```

- 设置事务隔离级别

  ```mysql
  SET  [ SESSION | GLOBAL ]  TRANSACTION  ISOLATION LEVEL  { READ UNCOMMITTED | READ COMMITTED | REPEATABLE READ | SERIALIZABLE }
  ```

> 事务隔离级别越高，数据越安全，但是性能越低。



# MySQL进阶篇

## 1.存储引擎

### 1.1 MySQL体系结构

![体系结构](https://jimhackking.github.io/%E8%BF%90%E7%BB%B4/MySQL%E5%AD%A6%E4%B9%A0%E7%AC%94%E8%AE%B0/MySQL%E4%BD%93%E7%B3%BB%E7%BB%93%E6%9E%84.png)

- 连接层

  > 最上层是一些客户端和链接服务，包含本地sock 通信和大多数基于客户端/服务端工具实现的类似于TCP/IP的通信。主要完成一些类似于连接处理、授权认证、及相关的安全方案。在该层上引入了线程 池的概念，为通过认证安全接入的客户端提供线程。同样在该层上可以实现基于SSL的安全链接。服务器也会为安全接入的每个客户端验证它所具有的操作权限。

- 服务层

  >第二层架构主要完成大多数的核心服务功能，如SQL接口，并完成缓存的查询，SQL的分析和优化，部分内置函数的执行。所有跨存储引擎的功能也在这一层实现，如 过程、函数等。在该层，服务器会解析查询并创建相应的内部解析树，并对其完成相应的优化如确定表的查询的顺序，是否利用索引等，最后生成相应的执行操作。如果是select语句，服务器还会查询内部的缓存，如果缓存空间足够大，这样在解决大量读操作的环境中能够很好的提升系统的性能。

- 引擎层

  >存储引擎层， 存储引擎真正的负责了MySQL中数据的存储和提取，服务器通过API和存储引擎进行通信。不同的存储引擎具有不同的功能，这样我们可以根据自己的需要，来选取合适的存储引擎。数据库中的索引是在存储引擎层实现的。

- 存储层

  >数据存储层，主要是将数据(如: redolog、undolog、数据、索引、二进制日志、错误日志、查询日志、慢查询日志等)存储在文件系统之上，并完成与存储引擎的交互。

### 1.2 存储引擎

>存储引擎就是存储数据、建立索引、更新/查询数据等技术的实现方式 。存储引擎是基于表的，而不是基于库的，所以存储引擎也可被称为`表类型`。可以在创建表的时候，来指定选择的存储引擎，如果没有指定将自动选择默认的存储引擎(InnoDB)。

```mysql
-- 查询建表语句
show create table account;  
-- 建表时指定存储引擎
CREATE TABLE 表名(
	...
) ENGINE=INNODB [COMMENT 表注释] ;
-- 查看当前数据库支持的存储引擎
show engines;
```

#### InnoDB

> 兼顾高可靠性和高性能的通用存储引擎，MySQL5.5后InnoDB 为默认MySQL 引擎。  

特点：

- DML 操作遵循 ACID 模型，支持**事务**
- **行级锁**，提高并发访问性能
- 支持**外键**约束，保证数据的完整性和正确性

文件：

- xxx.ibd: xxx代表表名，InnoDB 引擎的每张表都会对应这样一个表空间文件，存储该表的表结构（frm、sdi）、数据和索引。

参数：innodb_file_per_table，决定多张表共享一个表空间还是每张表对应一个表空间

```mysql
show variables like 'innodb_file_per_table';
```

从idb文件提取表结构数据：（cmd命令）  

``` mysql
ibd2sdi xxx.ibd
```

逻辑存储结构：

![逻辑存储结构](https://jimhackking.github.io/%E8%BF%90%E7%BB%B4/MySQL%E5%AD%A6%E4%B9%A0%E7%AC%94%E8%AE%B0/%E9%80%BB%E8%BE%91%E5%AD%98%E5%82%A8%E7%BB%93%E6%9E%84.png)

- 表空间 : InnoDB存储引擎逻辑结构的最高层，ibd文件其实就是表空间文件，在表空间中可以包含多个Segment段。

- 段 : 表空间是由各个段组成的，常见的段有数据段、索引段、回滚段等。InnoDB中对于段的管理，都是引擎自身完成，不需要人为对其控制，一个段中包含多个区。

- 区 : 区是表空间的单元结构，每个区的大小为1M。默认情况下， InnoDB存储引擎页大小为16K，即一个区中一共有64个连续的页。

- 页 : 页是组成区的最小单元， 页也是InnoDB存储引擎磁盘管理的最小单元，每个页的大小默认为 16KB。为了保证页的连续性，InnoDB存储引擎每次从磁盘申请4-5个区。

- 行 : InnoDB 存储引擎是面向行的，也就是说数据是按行进行存放的，在每一行中除了定义表时所指定的字段以外，还包含两个隐藏字段

#### MyISAM

> MySQL 早期的默认存储引擎

特点：

- 不支持事务，不支持外键
- 支持表锁，不支持行锁
- 访问速度快

文件：

- xxx.sdi: 存储表结构信息
- xxx.MYD: 存储数据
- xxx.MYI: 存储索引

#### Memory

> 表数据是存储在内存中的，受硬件问题、断电问题的影响，只能将这些表作为临时表或缓存使用。

特点：

- 存放在内存中，速度快
- hash索引（默认）

文件：

- xxx.sdi: 存储表结构信息

#### 存储引擎特点

| 特点         | InnoDB              | MyISAM | Memory |
| ------------ | ------------------- | ------ | ------ |
| 存储限制     | 64TB                | 有     | 有     |
| 事务安全     | 支持                | -      | -      |
| 锁机制       | 行锁                | 表锁   | 表锁   |
| B+tree索引   | 支持                | 支持   | 支持   |
| Hash索引     | -                   | -      | 支持   |
| 全文索引     | 支持（5.6版本之后） | 支持   | -      |
| 空间使用     | 高                  | 低     | N/A    |
| 内存使用     | 高                  | 低     | 中等   |
| 批量插入速度 | 低                  | 高     | 高     |
| 支持外键     | 支持                | -      | -      |

#### 存储引擎的选择

应根据应用系统的特点选择合适的存储引擎，对于复杂的应用系统，可根据实际情况选择多种存储引擎进行组合。

- InnoDB: 如果应用对事物的完整性有比较高的要求，在并发条件下要求数据的一致性，数据操作除了插入和查询之外，还包含很多的更新、删除操作，则 InnoDB 是比较合适的选择
- MyISAM: 如果应用是以读操作和插入操作为主，只有很少的更新和删除操作，并且对事务的完整性、并发性要求不高，那这个存储引擎是非常合适的。
- Memory: 将所有数据保存在内存中，访问速度快，通常用于临时表及缓存。Memory 的缺陷是对表的大小有限制，太大的表无法缓存在内存中，而且无法保障数据的安全性

电商中的足迹和评论适合使用 MyISAM 引擎，缓存适合使用 Memory 引擎。

### 1.3 性能分析

#### 1.3.1 查看执行频次

查看当前数据库的 INSERT, UPDATE, DELETE, SELECT 访问频次：
`SHOW GLOBAL STATUS LIKE 'Com_______';` 或者 `SHOW SESSION STATUS LIKE 'Com_______';`
例：`show global status like 'Com_______';`

#### 1.3.2 慢查询日志

慢查询日志记录了所有执行时间超过指定参数（long_query_time，单位：秒，默认10秒）的所有SQL语句的日志。
MySQL的慢查询日志默认没有开启，需要在MySQL的配置文件（/etc/my.cnf）中配置：

开启慢查询日志开关

​	`slow_query_log=1`

设置慢查询日志的时间为2秒，SQL语句执行时间超过2秒，就会视为慢查询，记录慢查询日志

​	`long_query_time=2`
更改后重启MySQL服务，日志文件位置：/var/lib/mysql/localhost-slow.log  

查看慢查询日志开关状态：
`show variables like 'slow_query_log';`  

#### 1.3.3 profile

show profile 能在做SQL优化时帮我们了解时间都耗费在哪里。通过 have_profiling 参数，能看到当前 MySQL 是否支持 profile 操作：
`SELECT @@have_profiling;`
profiling 默认关闭，可以通过set语句在session/global级别开启 profiling：
`SET profiling = 1;`
查看所有语句的耗时：
`show profiles;`
查看指定query_id的SQL语句各个阶段的耗时：
`show profile for query query_id;`
查看指定query_id的SQL语句CPU的使用情况
`show profile cpu for query query_id;`  

#### 1.3.4 explain

EXPLAIN 或者 DESC 命令获取 MySQL 如何执行 SELECT 语句的信息，包括在 SELECT 语句执行过程中表如何连接和连接的顺序。
语法：  

select语句之前加上关键字 explain / desc  

```mysql
EXPLAIN SELECT 字段列表 FROM 表名 HWERE 条件;  
```

EXPLAIN 各字段含义：  

- id：select 查询的序列号，表示查询中执行 select 子句或者操作表的顺序（id相同，执行顺序从上到下；id不同，值越大越先执行）。
- select_type：表示 SELECT 的类型，常见取值有 SIMPLE（简单表，即不适用表连接或者子查询）、PRIMARY（主查询，即外层的查询）、UNION（UNION中的第二个或者后面的查询语句）、SUBQUERY（SELECT/WHERE之后包含了子查询）等。 
- type：表示连接类型，性能由好到差的连接类型为 NULL、system、const、eq_ref、ref、range、index、all。
- possible_key：可能应用在这张表上的索引，一个或多个
- Key：实际使用的索引，如果为 NULL，则没有使用索引。
- Key_len：表示索引中使用的字节数，该值为索引字段最大可能长度，并非实际使用长度，在不损失精确性的前提下，长度越短越好。
- rows：MySQL认为必须要执行的行数，在InnoDB引擎的表中，是一个估计值，可能并不总是准确的。
- filtered：表示返回结果的行数占需读取行数的百分比，filtered的值越大越好。

## 2. 索引

>帮助 MySQL **高效获取数据**的**数据结构（有序）**

优点：

- 提高数据检索效率，降低数据库的IO成本  
- 通过索引列对数据进行排序，降低数据排序的成本，降低CPU的消耗

缺点：

- 索引列也是要占用空间的
- 索引大大提高了查询效率，但降低了更新的速度，比如 INSERT、UPDATE、DELETE

### 2.1 索引结构

| 索引结构            | 描述                                                         |
| ------------------- | ------------------------------------------------------------ |
| B+Tree              | 最常见的索引类型，大部分引擎都支持B+树索引                   |
| Hash                | 底层数据结构是用哈希表实现，只有精确匹配索引列的查询才有效，不支持范围查询 |
| R-Tree(空间索引)    | 空间索引是 MyISAM 引擎的一个特殊索引类型，主要用于地理空间数据类型，通常使用较少 |
| Full-Text(全文索引) | 是一种通过建立倒排索引，快速匹配文档的方式，类似于 Lucene, Solr, ES |

| 索引       | InnoDB        | MyISAM | Memory |
| ---------- | ------------- | ------ | ------ |
| B+Tree索引 | 支持          | 支持   | 支持   |
| Hash索引   | 不支持        | 不支持 | 支持   |
| R-Tree索引 | 不支持        | 支持   | 不支持 |
| Full-text  | 5.6版本后支持 | 支持   | 不支持 |

#### 二叉树

> 缺点：顺序插入时，会形成一个链表，查询性能大大降低。大数据量情况下，层级较深，检索速度慢。

![二叉树](https://jimhackking.github.io/%E8%BF%90%E7%BB%B4/MySQL%E5%AD%A6%E4%B9%A0%E7%AC%94%E8%AE%B0/%E4%BA%8C%E5%8F%89%E6%A0%91.png)

二叉树的链表缺点用红黑树解决：

#### 红黑树

> 缺点：大数据量情况下，层级较深，检索速度慢的问题。

![红黑树](https://jimhackking.github.io/%E8%BF%90%E7%BB%B4/MySQL%E5%AD%A6%E4%B9%A0%E7%AC%94%E8%AE%B0/%E7%BA%A2%E9%BB%91%E6%A0%91.png)

#### B Tree

> 以一棵最大度数（max-degree，指一个节点的子节点个数）为5（5阶）的 b tree 为例（每个节点最多存储4个key，5个指针）

![B-TREE](https://jimhackking.github.io/%E8%BF%90%E7%BB%B4/MySQL%E5%AD%A6%E4%B9%A0%E7%AC%94%E8%AE%B0/B-Tree%E7%BB%93%E6%9E%84.png)

>B-Tree 的数据插入过程动画参照：https://www.bilibili.com/video/BV1Kr4y1i7ru?p=68
>演示地址：https://www.cs.usfca.edu/~galles/visualization/BTree.html

#### B+Tree

![B+Tree](https://jimhackking.github.io/运维/MySQL学习笔记/B+Tree结构图.png)

> 演示地址：https://www.cs.usfca.edu/~galles/visualization/BPlusTree.html

与 B-Tree 的区别：

- 所有的数据都会出现在叶子节点
- 叶子节点形成一个单向链表

MySQL 索引数据结构对经典的 B+Tree 进行了优化。在原 B+Tree 的基础上，增加一个指向相邻叶子节点的链表指针，就形成了带有顺序指针的 B+Tree，`提高区间访问的性能。`

![mysql B+Tree](https://jimhackking.github.io/%E8%BF%90%E7%BB%B4/MySQL%E5%AD%A6%E4%B9%A0%E7%AC%94%E8%AE%B0/%E7%BB%93%E6%9E%84%E5%9B%BE.png)

#### Hash

> 哈希索引就是采用一定的hash算法，将键值换算成新的hash值，映射到对应的槽位上，然后存储在hash表中。如果两个（或多个）键值，映射到一个相同的槽位上，他们就产生了hash冲突（也称为hash碰撞），可以通过链表来解决。

特点：

- Hash索引只能用于对等比较（=、in），不支持范围查询（betwwn、>、<、...）
- 无法利用索引完成排序操作
- 查询效率高，通常只需要一次检索就可以了，效率通常要高于 B+Tree 索引

存储引擎支持：

- Memory
- InnoDB: 具有自适应hash功能，hash索引是存储引擎根据 B+Tree 索引在指定条件下自动构建的

#### 面试题

1. 为什么 InnoDB 存储引擎选择使用 B+Tree 索引结构？

- 相对于二叉树，层级更少，搜索效率高
- 对于 B-Tree，无论是叶子节点还是非叶子节点，都会保存数据，这样导致一页中存储的键值减少，指针也跟着减少，要同样保存大量数据，只能增加树的高度，导致性能降低
- 相对于 Hash 索引，B+Tree 支持范围匹配及排序操作

### 2.2 索引分类

| 分类     | 含义                                                 | 特点                     | 关键字   |
| -------- | ---------------------------------------------------- | ------------------------ | -------- |
| 主键索引 | 针对于表中主键创建的索引                             | 默认自动创建，只能有一个 | PRIMARY  |
| 唯一索引 | 避免同一个表中某数据列中的值重复                     | 可以有多个               | UNIQUE   |
| 常规索引 | 快速定位特定数据                                     | 可以有多个               |          |
| 全文索引 | 全文索引查找的是文本中的关键词，而不是比较索引中的值 | 可以有多个               | FULLTEXT |

在InnoDB存储引擎中，根据索引存储形式，又可分以下两种：

| 分类                      | 含义                                                       | 特点                 |
| ------------------------- | ---------------------------------------------------------- | -------------------- |
| 聚集索引(Clustered Index) | 将数据存储与索引放一块，索引结构的叶子节点保存了行数据     | 必须有，而且只有一个 |
| 二级索引(Secondary Index) | 将数据与索引分开存储，索引结构的叶子节点关联的是对应的主键 | 可以存在多个         |

![索引分类](https://jimhackking.github.io/%E8%BF%90%E7%BB%B4/MySQL%E5%AD%A6%E4%B9%A0%E7%AC%94%E8%AE%B0/%E5%8E%9F%E7%90%86%E5%9B%BE.png)

![索引分类](https://jimhackking.github.io/%E8%BF%90%E7%BB%B4/MySQL%E5%AD%A6%E4%B9%A0%E7%AC%94%E8%AE%B0/%E6%BC%94%E7%A4%BA%E5%9B%BE.png)

> select * from user where name = 'Arm';
>
> 具体过程如下:
> ①. 由于是根据name字段进行查询，所以先根据name='Arm'到name字段的二级索引中进行匹配查找。但是在二级索引中只能查找到Arm 对应的主键值10。
>
> ②. 由于查询返回的数据是*，所以此时，还需要根据主键值10，到聚集索引中查找10对应的记录，最终找到10对应的行row。
> ③. 最终拿到这一行的数据，直接返回即可。

聚集索引选取规则：

- 如果存在主键，主键索引就是聚集索引。
- 如果不存在主键，将使用第一个唯一(UNIQUE)索引作为聚集索引。
- 如果表没有主键或没有合适的唯一索引，则 InnoDB 会自动生成一个 rowid 作为隐藏的聚集索引。

#### 思考题

1\. 以下 SQL 语句，哪个执行效率高？为什么？

```mysql
elect * from user where id = 10;
select * from user where name = 'Arm';
-- 备注：id为主键，name字段创建的有索引
```

答：第一条语句，因为第二条需要回表查询，相当于两个步骤。

2\. InnoDB 主键索引的 B+Tree 高度为多少？

答：假设一行数据大小为1k，一页中可以存储16行这样的数据。InnoDB 的指针占用6个字节的空间，主键假设为bigint，占用字节数为8。

可得公式：`n * 8 + (n + 1) * 6 = 16 * 1024`，其中 8 表示 bigint 占用的字节数，n 表示当前节点存储的key的数量，(n + 1) 表示指针数量（比key多一个）。算出n约为1170。  

如果树的高度为2，那么他能存储的数据量大概为：`1171 * 16 = 18736`；
如果树的高度为3，那么他能存储的数据量大概为：`1171 * 1171 * 16 = 21939856`。  

另外，如果有成千上万的数据，那么就要考虑分表，涉及运维篇知识。  

### 2.3 语法

创建索引：
`CREATE [ UNIQUE | FULLTEXT ] INDEX index_name ON table_name (index_col_name, ...);`
如果不加 CREATE 后面不加索引类型参数，则创建的是常规索引  

查看索引：
`SHOW INDEX FROM table_name;`  

删除索引：
`DROP INDEX index_name ON table_name;`

```mysql
-- name字段为姓名字段，该字段的值可能会重复，为该字段创建索引
CREATE INDEX idx_user_name ON tb_user(name);
-- phone手机号字段的值非空，且唯一，为该字段创建唯一索引
CREATE UNIQUE INDEX idx_user_phone ON tb_user (phone);
-- 为profession, age, status创建联合索引
CREATE INDEX idx_user_pro_age_stat ON tb_user(profession, age, status);
-- 为email建立合适的索引来提升查询效率
CREATE INDEX idx_user_email ON tb_user(email);

-- 删除索引  
DROP INDEX idx_user_email ON tb_user;  
```

案例：

```mysql
create table tb_user(
    id int primary key auto_increment comment '主键',
    name varchar(50) not null comment '用户名',
    phone varchar(11) not null comment '手机号',
    email varchar(100) comment '邮箱',
    profession varchar(11) comment '专业',
    age tinyint unsigned comment '年龄',
    gender char(1) comment '性别, 1:男, 2:女',
    status char(1) comment '状态',
    createtime datetime comment '创建时间'
) comment '系统用户表';

INSERT INTO tb_user (name, phone, email, profession, age, gender, status, createtime) VALUES ('吕布', '17799990000','lvbu666@163.com', '软件工程', 23, '1', '6', '2001-02-02 00:00:00');
INSERT INTO tb_user (name, phone, email, profession, age, gender, status, createtime) VALUES ('曹操', '17799990001', 'caocao666@qq.com', '通讯工程', 33, '1', '0', '2001-03-05 00:00:00');
INSERT INTO tb_user (name, phone, email, profession, age, gender, status, createtime) VALUES ('赵云', '17799990002', '17799990@139.com', '英语', 34, '1', '2', '2002-03-02 00:00:00');
INSERT INTO tb_user (name, phone, email,profession, age, gender, status, 
createtime) VALUES ('孙悟空', '17799990003', '17799990@sina.com', '工程造价', 54, '1', '0', '2001-07-02 00:00:00');
INSERT INTO tb_user (name, phone, email, profession, age, gender, status, createtime) VALUES ('花木兰', '17799990004', '19980729@sina.com', '软件工程', 23, '2', '1', '2001-04-22 00:00:00');
INSERT INTO tb_user (name, phone, email, profession, age, gender, status, createtime) VALUES ('大乔', '17799990005', 'daqiao666@sina.com', '舞蹈', 22, '2', '0', '2001-02-07 00:00:00');
INSERT INTO tb_user (name, phone, email, profession, age, gender, status, createtime) VALUES ('露娜', '17799990006', 'luna_love@sina.com', '应用数学', 24, '2', '0', '2001-02-08 00:00:00'); 
INSERT INTO tb_user (name, phone, email, profession, age, gender, status, createtime) VALUES ('程咬金', '17799990007', 'chengyaojin@163.com', '化工', 38, '1', '5', '2001-05-23 00:00:00');
INSERT INTO tb_user (name, phone, email, profession, age, gender, status,createtime) VALUES ('项羽', '17799990008','xiaoyu666@qq.com', '金属材料', 43, '1', '0', '2001-09-18 00:00:00');
INSERT INTO tb_user (name, phone, email, profession, age, gender, status, createtime) VALUES ('白起', '17799990009','baiqi666@sina.com', '机械工程及其自动化', 27, '1', '2', '2001-08-16 00:00:00');
INSERT INTO tb_user (name, phone, email, profession, age, gender, status, createtime) VALUES ('韩信', '17799990010', 'hanxin520@163.com', '无机非金属材料工程', 27, '1', '0', '2001-06-12 00:00:00');
INSERT INTO tb_user (name, phone, email, profession, age, gender, status, createtime) VALUES ('荆轲', '17799990011','jingke123@163.com', '会计', 29, '1', '0', '2001-05-11 00:00:00');
INSERT INTO tb_user (name, phone, email, profession, age, gender, status, createtime) VALUES ('兰陵王', '17799990012','lanlinwang666@126.com', '工程造价', 44, '1', '1', '2001-04-09 00:00:00');
INSERT INTO tb_user (name, phone, email, profession, age, gender, status, createtime) VALUES ('狂铁', '17799990013','kuangtie@sina.com', '应用数学', 43,'1', '2', '2001-04-10 00:00:00');
INSERT INTO tb_user (name, phone, email, profession, age, gender, status, createtime) VALUES ('貂蝉', '17799990014','84958948374@qq.com', '软件工程', 40,'2', '3', '2001-02-12 00:00:00');
INSERT INTO tb_user (name, phone, email, profession, age, gender, status,createtime) VALUES ('妲己','17799990015','2783238293@qq.com', '软件工程', 31,'2', '0', '2001-01-30 00:00:00');
INSERT INTO tb_user (name, phone, email, profession, age, gender, status,createtime) VALUES ('芈月', '17799990016','xiaomin2001@sina.com', '工业经济', 35, '2', '0', '2000-05-03 00:00:00');
INSERT INTO tb_user (name, phone, email, profession, age, gender, status, createtime) VALUES ('嬴政', '17799990017','8839434342@qq.com', '化工', 38, '1','1', '2001-08-08 00:00:00');
INSERT INTO tb_user (name, phone, email, profession, age, gender, status,createtime) VALUES ('狄仁杰', '17799990018','jujiamlm8166@163.com', '国际贸易',30, '1', '0', '2007-03-12 00:00:00');
INSERT INTO tb_user (name, phone, email, profession, age, gender, status, createtime) VALUES ('安琪拉', '17799990019','jdodm1h@126.com', '城市规划', 51,'2', '0', '2001-08-15 00:00:00');
INSERT INTO tb_user (name, phone, email, profession, age, gender, status, createtime) VALUES ('典韦', '17799990020','ycaunanjian@163.com', '城市规划', 52, '1', '2', '2000-04-12 00:00:00');
INSERT INTO tb_user (name, phone, email, profession, age, gender, status, createtime) VALUES ('廉颇', '17799990021','lianpo321@126.com', '土木工程', 19,'1', '3', '2002-07-18 00:00:00');
INSERT INTO tb_user (name, phone, email, profession, age, gender, status, createtime) VALUES ('后羿', '17799990022','altycj2000@139.com', '城市园林', 20,'1', '0', '2002-03-10 00:00:00');
INSERT INTO tb_user (name, phone, email, profession, age, gender, status, createtime) VALUES ('姜子牙', '17799990023','37483844@qq.com', '工程造价', 29,'1', '4', '2003-05-26 00:00:00');
```

需求：

```mysql
A. name字段为姓名字段，该字段的值可能会重复，为该字段创建索引。
CREATE INDEX idx_user_name ON tb_user(name);

B. phone手机号字段的值，是非空，且唯一的，为该字段创建唯一索引。
CREATE UNIQUE INDEX idx_user_phone ON tb_user(phone);

C. 为profession、age、status创建联合索引。
CREATE INDEX idx_user_pro_age_sta ON tb_user(profession,age,status);

D. 为email建立合适的索引来提升查询效率。
CREATE INDEX idx_email ON tb_user(email);

查看tb_user表的所有的索引数据。
show index from tb_user;
```



### 2.4 使用规则

#### 最左前缀法则

如果索引关联了多列（联合索引），要遵守最左前缀法则，最左前缀法则指的是查询从索引的最左列开始，并且不跳过索引中的列。
如果跳跃某一列，索引将部分失效（后面的字段索引失效）。跳过的话，后面的排序就无从说起了。最左前缀法则在用select的时候，和放的位置是没有关系的，只要存在就行。  

联合索引中，出现范围查询（<, >），范围查询右侧的列索引失效。可以用>=或者<=来规避索引失效问题。  

#### 索引失效情况

1. 在索引列上进行运算操作，索引将失效。如：`explain select * from tb_user where substring(phone, 10, 2) = '15';` 换成 `explain select * from tb_user where phone = '17799990015';`这是可以的。  
2. 字符串类型字段使用时，不加引号，索引将失效。如：`explain select * from tb_user where phone = 17799990015;`，此处phone的值没有加引号  
3. 模糊查询中，如果仅仅是尾部模糊匹配，索引不会是失效；如果是头部模糊匹配，索引失效。如：`explain select * from tb_user where profession like '%工程';`，前后都有 % 也会失效。`explain select * from tb_user where profession like '软件%';` 这个是不会失效的，只有前面加了%才会失效。  
4. 用 or 分割开的条件，如果 or 其中一个条件的列没有索引，那么涉及的索引都不会被用到。
5. 如果 MySQL 评估使用索引比全表更慢，则不使用索引。因为只要有一个没有索引，另外一个用不用索引都没有意义，都要进行全表扫描。所以就无需用索引。

#### SQL 提示

优化数据库的一个重要手段，就是在SQL语句中加入一些人为的提示来达到优化操作的目的。  

例如，使用索引：
`explain select * from tb_user use index(idx_user_pro) where profession="软件工程";`
不使用哪个索引：
`explain select * from tb_user ignore index(idx_user_pro) where profession="软件工程";`
必须使用哪个索引：
`explain select * from tb_user force index(idx_user_pro) where profession="软件工程";`

use 是建议，实际使用哪个索引 MySQL 还会自己权衡运行速度去更改，force就是无论如何都强制使用该索引。

#### 覆盖索引&回表查询

尽量使用覆盖索引（查询使用了索引，并且需要返回的列，在该索引中已经全部能找到），减少 select *。

explain 中 extra 字段含义：
`using index condition`：查找使用了索引，但是需要回表查询数据
`using where; using index;`：查找使用了索引，但是需要的数据都在索引列中能找到，所以不需要回表查询

- 覆盖索引：

  - 如果在生成的二级索引（辅助索引）中可以一次性获得select所需要的字段，不需要回表查询。

  - 如果在聚集索引中直接能找到对应的行，则直接返回行数据，只需要一次查询，哪怕是select \*；
  - 如果在辅助索引（二级索引）中找聚集索引，如`select id, name from xxx where name='xxx';`，也只需要通过辅助索引(name)查找到对应的id，返回name和name索引对应的id即可，只需要一次查询； 
  - 如果是通过辅助索引查找其他字段，则需要回表查询，如`select id, name, gender from xxx where name='xxx';`  

所以尽量不要用`select *`，容易出现回表查询，降低效率，除非有联合索引包含了所有字段  

面试题：

一张表，有四个字段（id, username, password,status），由于数据量大，需要对以下SQL语句进行优化，该如何进行才是最优方案：
`select id, username, password from tb_user where username='coisini';`

解：

给username和password字段建立联合索引，则不需要回表查询，直接覆盖索引。username和password字段建立联合索引的叶子节点挂的就是 id 所以不需要三者同时建索引。

#### 前缀索引

当字段类型为字符串（varchar, text等）时，有时候需要索引很长的字符串，这会让索引变得很大，查询时，浪费大量的磁盘IO，影响查询效率，此时可以只降字符串的一部分前缀，建立索引，这样可以大大节约索引空间，从而提高索引效率。

语法：

```mysql
create index idx_xxxx on table_name(columnn(n));
```

> 例如：为tb_user表的email字段，建立长度为5的前缀索引。
>
> create index idx_email_5 on tb_user(email(5));

前缀长度：可以根据索引的选择性来决定，而选择性是指不重复的索引值（基数）和数据表的记录总数的比值，索引选择性越高则查询效率越高，唯一索引的选择性是1，这是最好的索引选择性，性能也是最好的。  

求选择性公式：  

```mysql
select count(distinct email) / count(*) from tb_user;
select count(distinct substring(email, 1, 5)) / count(*) from tb_user;
```

前缀索引中是有可能碰到相同的索引的情况的（因为选择性可能不为1），所以使用前缀索引进行查询的时候，mysql 会有一个回表查询的过程，确定是否为所需数据。如图中的查询到lvbu6之后还要进行回表，回表完再查xiaoy，看到xiaoy是不需要的数据，则停止查下一个。

![前缀索引](http://cdn.coisini.cn/axz/image-20241006204752506.png)

#### 单列索引&联合索引

> 单列索引：即一个索引只包含单个列
> 联合索引：即一个索引包含了多个列

在业务场景中，如果存在多个查询条件，考虑针对于查询字段建立索引时，建议建立联合索引，而非单列索引。

单列索引情况：

```mysql
explain select id, phone, name from tb_user where phone = '17799990010' and name = '韩信';
```

phone 和 name 都建立了索引情况下，这句只会用到phone索引字段。

![单列索引](http://cdn.coisini.cn/axz/image-20241006205204308.png)

##### 注

- 多条件联合查询时，MySQL优化器会评估哪个字段的索引效率更高，会选择该索引完成本次查询。

### 2.5 设计原则

1. 针对于数据量较大，且查询比较频繁的表建立索引。
2. 针对于常作为查询条件（where）、排序（order by）、分组（group by）操作的字段建立索引。
3. 尽量选择区分度高的列作为索引，尽量建立唯一索引，区分度越高，使用索引的效率越高。
4. 如果是字符串类型的字段，字段长度较长，可以针对于字段的特点，建立前缀索引。
5. 尽量使用联合索引，减少单列索引，查询时，联合索引很多时候可以覆盖索引，节省存储空间，避免回表，提高查询效率。
6. 要控制索引的数量，索引并不是多多益善，索引越多，维护索引结构的代价就越大，会影响增删改的效率。
7. 如果索引列不能存储NULL值，请在创建表时使用NOT NULL约束它。当优化器知道每列是否包含NULL值时，它可以更好地确定哪个索引最有效地用于查询。

## 3. SQL优化

### 3.1 插入数据

普通插入：

1. 采用批量插入（一次插入的数据不建议超过1000条，500 - 1000 为宜）
2. 手动提交事务
3. 主键顺序插入（主键顺序插入的效率大于乱序插入）

```mysql
insert into tb_test values(1,'tom');
insert into tb_test values(2,'cat');
insert into tb_test values(3,'jerry');

1). 优化方案一 
批量插入数据
Insert into tb_test values(1,'Tom'),(2,'Cat'),(3,'Jerry');

2). 优化方案二
手动控制事务
start  transaction;
insert into tb_test values(1,'Tom'),(2,'Cat'),(3,'Jerry');
insert into tb_test values(4,'Tom'),(5,'Cat'),(6,'Jerry');
insert into tb_test values(7,'Tom'),(8,'Cat'),(9,'Jerry');
commit;

3). 优化方案三
主键顺序插入，性能要高于乱序插入。
主键乱序插入 : 8 1 9 21 88 2 4 15 89 5 7 3
主键顺序插入 : 1 2 3 4 5 7 8 9 15 21 88 89

```





大批量插入：
如果一次性需要插入大批量数据，使用insert语句插入性能较低，此时可以使用MySQL数据库提供的load指令插入。

```mysql
# 客户端连接服务端时，加上参数 --local-infile（cmd命令行输入）
mysql --local-infile -u root -p
# 设置全局参数local_infile为1，开启从本地加载文件导入数据的开关
set global local_infile = 1;
select @@local_infile;
# 执行load指令将准备好的数据，加载到表结构中，先要把表建立起来。
load data local infile '/root/sql1.log' into table 'tb_user' fields terminated by ',' lines terminated by '\n';
```

### 3.2 主键优化

- 数据组织方式：在InnoDB存储引擎中，表数据都是根据主键顺序组织存放的，这种存储方式的表称为索引组织表（Index organized table, IOT）

![数据组织方式](http://cdn.coisini.cn/axz/image-20241006211003471.png)

- 页分裂：页可以为空，也可以填充一般，也可以填充100%，每个页包含了2-N行数据（如果一行数据过大，会行溢出），根据主键排列。
- 页合并：当删除一行记录时，实际上记录并没有被物理删除，只是记录被标记（flaged）为删除并且它的空间变得允许被其他记录声明使用。当页中删除的记录到达 MERGE_THRESHOLD（默认为页的50%），InnoDB会开始寻找最靠近的页（前后）看看是否可以将这两个页合并以优化空间使用。MERGE_THRESHOLD：合并页的阈值，可以自己设置，在创建表或创建索引时指定

>具体可以看视频里的PPT演示过程：https://www.bilibili.com/video/BV1Kr4y1i7ru?p=90

主键设计原则：

- 满足业务需求的情况下，尽量降低主键的长度，二级索引的叶子节点保存的就是主键，所以主键小占用的空间也就会少。
- 插入数据时，尽量选择顺序插入，选择使用 AUTO_INCREMENT 自增主键
- 尽量不要使用 UUID 做主键或者是其他的自然主键，如身份证号，占用的空间大。
- 业务操作时，避免对主键的修改

### 3.3 order by优化

1. Using filesort：通过表的索引或全表扫描，读取满足条件的数据行，然后在排序缓冲区 sort buffer 中完成排序操作，所有不是通过索引直接返回排序结果的排序都叫 FileSort 排序
2. Using index：通过有序索引顺序扫描直接返回有序数据，这种情况即为 using index，不需要额外排序，操作效率高

如果order by字段全部使用升序排序或者降序排序，则都会走索引，但是如果一个字段升序排序，另一个字段降序排序，则不会走索引，explain的extra信息显示的是`Using index, Using filesort`，如果要优化掉Using filesort，则需要另外再创建一个索引，如：`create index idx_user_age_phone_ad on tb_user(age asc, phone desc);`，此时使用`select id, age, phone from tb_user order by age asc, phone desc;`会全部走索引

```mysql
# 为tb_user表所建立的部分索引直接删除掉
drop index idx_user_phone on tb_user;
drop index idx_user_phone_name on tb_user;
drop index idx_user_name on tb_user;

# 执行排序SQL
explain select id,age,phone from tb_user order by age ;
explain select  id,age,phone from tb_user order by age, phone ;

由于 age, phone 都没有索引，所以此时再排序时，出现Using filesort， 排序性能较低。

-- 创建索引
create index idx_user_age_phone_aa on tb_user(age,phone);
# 创建索引后，根据age, phone进行升序排序
explain select  id,age,phone from tb_user order by age;
explain select  id,age,phone from tb_user order by age , phone;

建立索引之后，再次进行排序查询，就由原来的Using filesort，变为了Using index，性能就是比较高的了。


# 创建索引后，根据age, phone进行降序排序
explain select id,age,phone from tb_user order by age desc , phone desc ;

也出现 Using index，但是此时Extra中出现了     Backward index scan，这个代表反向扫描索引，因为在MySQL中我们创建的索引，默认索引的叶子节点是从小到大排序的，而此时我们查询排序时，是从大到小，所以，在扫描时，就是反向扫描，就会出现Backward index scan。     在MySQL8版本中，支持降序索引，我们也可以创建降序索引。


# 根据phone，age进行升序排序，phone在前，age在后。
explain select id,age,phone from tb_user order by phone , age;
排序时,也需要满足最左前缀法则,否则也会出现filesort。因为在创建索引的时候，age是第一个字段，phone是第二个字段，所以排序时，也就该按照这个顺序来，否则就会出现     Using filesort。

# 根据age, phone进行降序一个升序，一个降序
explain select id,age,phone from tb_user order by age asc , phone desc ;

创建索引时，如果未指定顺序，默认都是按照升序排序的，而查询时，一个升序，一个降序，此时就会出现Using filesort。

为了解决上述的问题，创建一个索引，这个联合索引中     age 升序排序，phone 倒序排序。
# 创建联合索引(age 升序排序，phone 倒序排序)
create index  idx_user_age_phone_ad on tb_user(age asc ,phone desc);

# 再次执行如下SQL
explain select id,age,phone from tb_user order by age asc , phone desc ;
```



总结：

- 根据排序字段建立合适的索引，多字段排序时，也遵循最左前缀法则
- 尽量使用覆盖索引
- 多字段排序，一个升序一个降序，此时需要注意联合索引在创建时的规则（ASC/DESC）
- 如果不可避免出现filesort，大数据量排序时，可以适当增大排序缓冲区大小 sort_buffer_size（默认256k）

### 3.4 group by优化

- 在分组操作时，可以通过索引来提高效率
- 分组操作时，索引的使用也是满足最左前缀法则的

如索引为`idx_user_pro_age_stat`，则句式可以是`select ... where profession order by age`，这样也符合最左前缀法则

```mysql
# 先将tb_user 表的索引全部删除掉
drop index idx_user_pro_age_sta on tb_user;
drop index idx_email_5 on tb_user;
drop index idx_user_age_phone_aa on tb_user;
drop index idx_user_age_phone_ad on tb_user;

# 执行如下SQL，查询执行计划
explain select profession , count(*) from tb_user  group by profession ;

# 针对于profession ，age，status 创建一个联合索引
create index  idx_user_pro_age_sta  on tb_user(profession , age , status);

# 再执行前面相同的SQL查看执行计划。
explain select profession , count(*) from tb_user  group by profession ;

如果仅仅根据age分组，就会出现Using temporary ；而如果是根据 profession,age两个字段同时分组，则不会出现 Using temporary。
原因是因为对于分组操作，在联合索引中，也是符合最左前缀法则的。
```



### 3.5 limit优化

常见的问题如`limit 2000000, 10`，此时需要 MySQL 排序前2000000条记录，但仅仅返回2000000 - 2000010的记录，其他记录丢弃，查询排序的代价非常大。
优化方案：一般分页查询时，通过创建覆盖索引能够比较好地提高性能，可以通过覆盖索引加子查询形式进行优化

```mysql
-- 此语句耗时很长
select * from tb_sku limit 9000000, 10;
-- 通过覆盖索引加快速度，直接通过主键索引进行排序及查询
select id from tb_sku order by id limit 9000000, 10;
-- 下面的语句是错误的，因为 MySQL 不支持 in 里面使用 limit
-- select * from tb_sku where id in (select id from tb_sku order by id limit 9000000, 10);
-- 通过连表查询即可实现第一句的效果，并且能达到第二句的速度
select * from tb_sku as s, (select id from tb_sku order by id limit 9000000, 10) as a where s.id = a.id;
```

### 3.6 count优化

> MyISAM 引擎把一个表的总行数存在了磁盘上，因此执行 count(\*) 的时候会直接返回这个数，效率很高（前提是不适用where）；
> InnoDB 在执行 count(\*) 时，需要把数据一行一行地从引擎里面读出来，然后累计计数。

优化方案：自己计数，如创建key-value表存储在内存或硬盘，或者是用redis。

count的几种用法：

- 如果count函数的参数（count里面写的那个字段）不是NULL（字段值不为NULL），累计值就加一，最后返回累计值 
- 用法：count(\*)、count(主键)、count(字段)、count(1)
- count(主键)跟count(\*)一样，因为主键不能为空；count(字段)只计算字段值不为NULL的行；count(1)引擎会为每行添加一个1，然后就count这个1，返回结果也跟count(\*)一样；count(null)返回0

各种用法的性能：

- count(主键)：InnoDB引擎会遍历整张表，把每行的主键id值都取出来，返回给服务层，服务层拿到主键后，直接按行进行累加（主键不可能为空）
- count(字段)：没有not null约束的话，InnoDB引擎会遍历整张表把每一行的字段值都取出来，返回给服务层，服务层判断是否为null，不为null，计数累加；有not null约束的话，InnoDB引擎会遍历整张表把每一行的字段值都取出来，返回给服务层，直接按行进行累加
- count(1)：InnoDB 引擎遍历整张表，但不取值。服务层对于返回的每一层，放一个数字 1 进去，直接按行进行累加
- count(\*)：InnoDB 引擎并不会把全部字段取出来，而是专门做了优化，不取值，服务层直接按行进行累加

按效率排序：count(字段) < count(主键) < count(1) < count(\*)，所以尽量使用 count(\*)



| count用法    | 含义                                                         |
| ------------ | ------------------------------------------------------------ |
| count(主键)  | InnoDB 引擎会遍历整张表，把每一行的主键id 值都取出来，返回给服务层。服务层拿到主键后，直接按行进行累加(主键不可能为null) |
| count(字 段) | 没有not null 约束 : InnoDB 引擎会遍历整张表把每一行的字段值都取出 来，返回给服务层，服务层判断是否为null，不为null，计数累加。有not null 约束：InnoDB 引擎会遍历整张表把每一行的字段值都取出来，返回给服务层，直接按行进行累加。 |
| count(数 字) | InnoDB 引擎遍历整张表，但不取值。服务层对于返回的每一行，放一个数字“1”进去，直接按行进行累加。 |
| count(*)     | InnoDB引擎并不会把全部字段取出来，而是专门做了优化，不取值，服务层直接按行进行累加。 |



### 3.7 update优化（避免行锁升级为表锁）

> InnoDB 的行锁是针对索引加的锁，不是针对记录加的锁，并且该索引不能失效，否则会从行锁升级为表锁。

如以下两条语句：
`update student set no = '123' where id = 1;`

> 在执行删除的SQL语句时。会锁定id为1这一行的数据。然后事务提交之后，行锁释放。由于id有主键索引，所以只会锁这一行；

`update student set no = '123' where name = 'coisini';`，

> 由于name没有索引，所以会把整张表都锁住进行数据更新，解决方法是给name字段添加索引，就可以由表锁变成行锁。  

## 4. 视图/存储过程/触发器

### 4.1 视图

>视图（View）是一种虚拟存在的表。视图中的数据并不在数据库中实际存在，行和列数据来自定义视图的查询中使用的表，并且是在使用视图时动态生成的。
>通俗的讲，视图只保存了查询的SQL逻辑，不保存查询结果。所以我们在创建视图的时候，主要的工作就落在创建这条SQL查询语句上。

语法：

#### 4.1.1 创建视图

```mysql
CREATE [ OR REPLACE ] VIEW 视图名称[（列名列表）] AS SELECT 语句 [ WITH [ CASCADED | LOCAL ] CHECK OPTION ]
```

案例： 

> ```mysql
> create or replace view stu_wll as select id,name from student where id<=10;
> ```

#### 4.1.2 查询视图

查看创建视图语句： `SHOW CREATE VIEW `视图名称；  

查看视图数据：`SELECT*FROM ` 视图名称；

```mysql
show create view stu_v_1;
```

#### 4.1.3 修改视图

方式一：

```mysql
CREATE[OR REPLACE] VIEW 视图名称[（列名列表)）] AS SELECT 语句[ WITH[ CASCADED | LOCAL ] CHECK OPTION ]
```

方式二：

```mysql
ALTER VIEW 视图名称 [（列名列表)] AS SELECT语句 [WITH [CASCADED | LOCAL] CHECK OPTION]
```

#### 4.1.4 删除视图

```mysql
DROP VIEW [IF EXISTS] 视图名称 [视图名称]
```

#### --案例

```mysql
-- 创建视图
create or replace view stu_v_1 as select id,name from student where id <= 10;

-- 查询视图
show create view stu_v_1;

select * from stu_v_1;
select * from stu_v_1 where id < 3;

-- 修改视图
create or replace view stu_v_1 as select id,name,no from student where id <= 10;

alter view stu_v_1 as select id,name from student where id <= 10;

-- 删除视图
drop view if exists stu_v_1;
```

测试：

```mysql
create or replace view stu_v_1 as select id,name from student where id <= 10 ;

select * from stu_v_1;
   
insert into stu_v_1 values(6,'Tom');
   
insert into stu_v_1 values(17,'Tom22');
```

>id为6和17的数据都是可以成功插入的。但执行查询出来的数据，没有id为17的记录。
>
>在创建视图的时候，指定的条件为id<=10, id为17的数据，不符合条件。

定义视图时，如果指定了条件，然后在插入、修改、删除数据时，是否可以做到必须满足 条件才能操作，否则不能够操作呢？需要借助于视图的检查选项。如下介绍：

#### 4.1.5 视图检查选项

>当使用WITH CHECK QPTION子句创建视图时，MySQL会通过视图检查正在更改的每个行，例如插入，更新，删除，以使其符合视图的定义。MySQL允许基于另一个视图创建视图，它还会检查依赖视图中的规则以保持一致性。为了确定检查的范围，mysql提供了两个选项：CASCADED 和 LOCAL ，默认值为 CASCADED。

如果没有开检查选项就不会进行检查，不同版本不同含义，需要看版本。

##### CASCADED

`级联，一旦选择了这个选项，除了会检查创建视图时候的条件，还会检查所依赖视图的条件。`

> 比如：
>
> 创建stu_V_l 视图，id小于等于 20。
> `create or replace view stu_V_l as select id,name from student where id <=20;`
> 再创建 stu_v_2 视图，20 >= id >=10。
> `create or replace view stu_v_2 as select id,name from stu_v_1 where id >=10 with cascaded check option;`
> 再创建 stu_v_3 视图。
> `create or replace view stu_v_3 as select id,name from stu_v_2 where id<=15;`
> 这条数据能够成功，stu_v_3 没有开检查选项所以不会去判断 id 是否小于等于15, 直接检查是否满足 stu_v_2。 
> `insert into stu_v_3 values(17,'Tom');`

##### LOCAL

本地

>v2视图是基于v1视图的，如果在v2视图创建的时候指定了检查选项为local，但是v1视图创建时未指定检查选项。     则在执行检查时，只会检查v2，不会检查v2的关联视图v1。

和 CASCADED 的区别就是 CASCADED 不管上面开没开检查选项都会进行检查。

#### 4.1.6 视图更新

> 要使视图可更新，视图中的行与基础表中的行之间必须存在一对一的关系。如果视图包含以下任何一项，则该视图不可更新；

- 聚合函数或窗口函数 ( SUM()、MIN()、MAX()、COUNT() 等 )

- DISTINCT

- GROUP BY

- HAVING

- UNION 或者UNION ALL



- >使用了聚合函数，插入会失败。
  >
  >```mysql
  >create view stu_v_count as select count(*) from student;
  >-- 上述视图只有一个单行单列的数据，如果对视图进行更新或插入的，将会报错。
  >insert into stu_v_count values(10);
  >```

#### 4.1.7 视图作用

简单

>视图不仅可以简化用户对数据的理解，也可以简化操作。那些被经常使用的查询可以被定义为视图，从而使得用户不必为以后的操作每次指定全部的条件。 

安全

> 数据库可以授权，但不能授权到数据库特定行和特定的列上。通过视图用户只能查询和修改他们所能见到的数据。

数据独立

> 视图可帮助用户屏蔽真实表结构变化带来的影响。

#### --案例

为了保证数据库表的安全性，开发人员在操作tb_user表时，只能看到的用户的基本字段，屏蔽手机号和邮箱两个字段。

```mysql
create view tb_user_view as select id,name,profession,age,gender,status,createtime from tb_user;

select * from tb_user_view;
```

查询每个学生所选修的课程（三张表联查），这个功能在很多的业务中都有使用到，为了简化操作，定义一个视图。

```mysql
create view tb_stu_course_view as select s.name student_name , s.no student_no, c.name course_name from student s, student_course sc , course c where s.id = sc.studentid and sc.courseid = c.id;

select * from tb_stu_course_view;
```



### 4.2 存储过程

>存储过程是事先经过编译并存储在数据库中的一段SQL 语句的集合，调用存储过程可以简化应用开发人员的很多工作，减少数据在数据库和应用服务器之间的传输，对于提高数据处理的效率是有好处的。
>
>存储过程思想上很简单，就是数据库SQL语言层面的代码封装与重用。

特点：

1. 封装，复用 

   > 把某一业务SQL封装在存储过程中，需要用到的时候直接调用即可。

2. 可以接收参数，也可以返回数据 

   > 再存储过程中，可以传递参数，也可以接收返回值。

3. 减少网络交互，效率提升

   > 如果涉及到多条SQL，每执行一次都是一次网络传 
   > 输。而如果封装在存储过程中，我们只需要网络交互一次可能就可以了。

#### 4.2.1 创建

> 在命令行中，执行创建存储过程的SQL时，需要通过关键字delimiter 指定SQL语句的结束符。默认是分号作为结束符。

```mysql
CREATE PROCEDURE 存储过程名称( [参数列表] ) 
BEGIN
	 SQL 语句 
END;
```

#### 4.2.2 调用

```mysql
CALL 名称 ( [参数])
```

#### 4.2.3 查看

```mysql
-- 查询指定数据库的存储过程及状态信息
SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_SCHEMA = 'xxx';

-- 查询某个存储过程的定义
SHOW CREATE PROCEDURE 存储过程名称;  
```

#### 4.2.4 删除

```mysql
DROP PROCEDURE [ IF EXISTS ] 存储过程名称;
```

>在命令行中，执行创建存储过程的SQL时，需要通过关键字     delimiter 指定SQL语句的结束符。

#### -- 案例

```mysql
-- 存储过程基本语法
-- 创建
create procedure p1()
begin
	select count(*) from student;
end;

-- 调用
call p1();

-- 查看
select * from information_schema.ROUTINES where ROUTINE_SCHEMA = 'coisini';

show create procedure p1;

-- 删除
drop procedure if exists p1;
```

#### 4.2.5 变量

> 三种类型: 系统变量、用户定义变量、局部变量.

##### 4.2.5.1 系统变量

>系统变量是MySQL服务器提供，不是用户定义的，属于服务器层面。分为全局变量（GLOBAL）、会话变量（SESSION）。

- 查看系统变量

  ```mysql
  -- 查看所有系统变量
  SHOW  [ SESSION | GLOBAL ]   VARIABLES ;
  
  -- 可以通过LIKE模糊匹配方式查找变量
  SHOW [ SESSION | GLOBAL ] VARIABLES LIKE '......';
  
  --  查看指定变量的值
  SELECT @@[SESSION | GLOBAL]  系统变量名;
  ```

- 设置变量

  ```mysql
  SET [ SESSION | GLOBAL ] 系统变量名 = 值 ;
  SET  @@[SESSION | GLOBAL]系统变量名 = 值  ;
  ```

  > 如果没有指定SESSION/GLOBAL，默认是SESSION，会话变量。
  >
  > mysql服务重新启动之后，所设置的全局参数会失效，要想不失效，可以在/etc/my.cnf 中配置。
  >
  > - 全局变量(GLOBAL): 全局变量针对于所有的会话。
  > - 会话变量(SESSION): 会话变量针对于单个会话，在另外一个会话窗口就不生效了。

示例：

```mysql
-- 查看系统变量
show session variables ;
show session variables like 'auto%';
show global variables like 'auto%';

select @@global.autocommit;
select @@session.autocommit;


-- 设置系统变量
set session autocommit = 1;
   
insert into course(id, name) VALUES (6, 'ES');
 
set global autocommit  = 0;
   
select @@global.autocommit;
```

##### 4.2.5.2 用户定义变量

用户定义变量是用户根据需要自己定义的变量，用户变量不用提前声明，在用的时候直接用"@变量名" 使用就可以。其作用域为当前连接。

- 赋值

  方式一

  ```mysql
  SET   @var_name = expr  [, @var_name = expr] ... ;
  SET @var_name := expr [, @var_name := expr] ... ;
  ```

  >赋值时，可以使用= ，也可以使用:= 。

​	方式二

```mysql
SELECT @var_name := expr [, @var_name := expr] ... ;
SELECT 字段名 INTO @var_name FROM 表名;
```

- 使用

  ```mysql
  SELECT  @var_name ;
  ```

  >用户定义的变量无需对其进行声明或初始化，只不过获取到的值为NULL。

示例：

```mysql
-- 赋值
set @myname = 'itcast';
set @myage := 10;
set @mygender := '男',@myhobby := 'java';

select @mycolor := 'red';
select count(*) into @mycount from tb_user;

-- 使用
select @myname,@myage,@mygender,@myhobby;

select @mycolor , @mycount;
select @abc;
```

##### 4.2.5.3 局部变量

>根据需要定义的在局部生效的变量，访问之前，需要DECLARE声明。可用作存储过程内的局部变量和输入参数，局部变量的范围是在其内声明的BEGIN ... END块。

- 申明

```mysql
DECLARE 变量名 变量类型 [DEFAULT ... ];
```

>变量类型就是数据库字段类型：INT、BIGINT、CHAR、VARCHAR、DATE、TIME等。

- 赋值

```mysql
SET  变量名 = 值;
SET  变量名 := 值;
SELECT 字段名 INTO 变量名 FROM 表名 ...;
```

示例：

```mysql
-- 声明局部变量    - declare
-- 赋值
create procedure p2()
begin
	declare stu_count int default 0;
	select count(*) into stu_count from student;
	select stu_count;
end;

call p2();
```

#### 4.2.6 if

> 条件判断
>
> 在if条件判断的结构中，ELSE IF 结构可以有多个，也可以没有。ELSE结构可以有，也可以没有。

```mysql
IF  条件1  THEN
	.....
ELSEIF  条件2  THEN      -- 可选
	.....
ELSE 	-- 可选
	.....
END  IF;
```

示例：

根据定义的分数score变量，判定当前分数对应的分数等级。
score >= 85分，等级为优秀。
score >= 60分  且 score < 85分，等级为及格。
score < 60分，等级为不及格。

```mysql
create procedure p3()
begin
	 declare score int default 58;
     declare result varchar(10);
 
 	if score >= 85 then
    	set result := '优秀';
    elseif score >= 60 then
    	set result := '及格';
 	else
 		set result := '不及格';
 	end if;
 	select result;
 end;
 
 call p3();
```

> 分析：
>
> score 分数在存储过程中固定，最终计算出来的分数等级，也仅仅是最终查询展示。
>
> 需求：
>
> 把score分数动态的传递进来，计算出来的分数等级是否可以作为返回值返回呢？ 
> 使用 参数来解决上述的问题。

#### 4.2.7 参数

> 分为种：IN、OUT、INOUT

| 类型  | 含义                                         | 备注 |
| ----- | -------------------------------------------- | ---- |
| IN    | 该类参数作为输入，也就是需要调用时传入值     | 默认 |
| OUT   | 该类参数作为输出，也就是该参数可以作为返回值 |      |
| INOUT | 既可以作为输入参数，也可以作为输出参数       |      |

用法：

```mysql'
CREATE PROCEDURE 存储过程名称([ IN/OUT/INOUT 参数名 参数类型])

BEGIN;
-- SQL语句
END;
```

案例一：

>根据传入参数score，判定当前分数对应的分数等级，并返回。
>
>- score >= 85分，等级为优秀。
>- score >= 60分  且 score < 85分，等级为及格。
>- score < 60分，等级为不及格。

```mysql
create procedure p4(in score int, out result varchar(10))
   begin
       if score >= 85 then
           set result := '优秀';
       elseif score >= 60 then
       		set result := '及格';
       else
           	set result := '不及格';
       end if;
   end;
   
-- 定义用户变量 @result来接收返回的数据, 用户变量可以不用声明
call p4(18, @result);

select @result;
```

案例二：

> 将传入的200分制的分数，进行换算，换算成百分制，然后 返回 

```mysql
create procedure p5(inout score double)
begin
    set score := score * 0.5;
end;

set @score = 198;
call p5(@score);

select @score;
```

#### 4.2.8 case

语法一：

```mysql
-- 含义：当case_value的值为when_value1时，执行statement_list1，当值为when_value2时， 执行statement_list2，否则就执行statement_list

CASE  case_value
       WHEN  when_value1  THEN  statement_list1
      [ WHEN  when_value2  THEN  statement_list2] ...
      [ ELSE  statement_list ]
END  CASE;
```

语法二：

```mysql
-- 含义：当条件search_condition1成立时，执行statement_list1，当条件search_condition2成立时，执行statement_list2，    否则就执行    statement_list

CASE
     WHEN  search_condition1  THEN  statement_list1
     [WHEN  search_condition2  THEN  statement_list2] ...
     [ELSE  statement_list]
END CASE;
```

案例：

> 根据传入的月份，判定月份所属的季节（要求采用case结构）。
>
> - 1-3月份，为第一季度
> - 4-6月份，为第二季度
> - 7-9月份，为第三季度
> - 10-12月份，为第四季度

```mysql
create procedure p6(in month int)
begin
	declare result varchar(10);
	case
		when month >= 1 and month <= 3 then
			set result := '第一季度';
        when month >= 4 and month <= 6 then
        	set result := '第二季度';
        when month >= 7 and month <= 9 then
        	set result := '第三季度';
        when month >= 10 and month <= 12 then
        	set result := '第四季度';
        else
        	set result := '非法参数';
	end case ;

	select concat('您输入的月份为: ',month, ', 所属的季度为: ',result);
end;

call  p6(16);
```

> 如果判定条件有多个，多个条件之间，可以使用and或     or进行连接。

#### 4.2.9 while

> while 循环是有条件的循环控制语句。满足条件后，再执行循环体中的SQL语句。

```mysql
-- 先判定条件，如果条件为true，则执行逻辑，否则，不执行逻辑
WHILE  条件 DO
	SQL逻辑...
END WHILE;
```

案例：

> 计算从1累加到n的值，n为传入的参数值。

```mysql
-- A. 定义局部变量, 记录累加之后的值;
-- B. 每循环一次, 就会对n进行减1 , 如果n减到0, 则退出循环

create procedure p7(in n int)
begin
	declare total int default 0;
	while n>0 do
		set total := total + n;
		set n := n - 1;
	end while;
	
	select total;
end;

call p7(100)
```

#### 4.2.10 repeat

> repeat是有条件的循环控制语句, 当满足until声明的条件的时候，则退出循环 。

```mysql
-- 先执行一次逻辑，然后判定UNTIL条件是否满足，如果满足，则退出。如果不满足，则继续下一次循环
REPEAT
       SQL逻辑...
       UNTIL  条件
END REPEAT;
```

案例:

>计算从1累加到n的值，n为传入的参数值。(使用repeat实现)

```mysql
-- A. 定义局部变量, 记录累加之后的值;
-- B. 每循环一次, 就会对n进行-1 , 如果n减到0, 则退出循环
create procedure p8(in n int)
begin
	declare total int default 0;
	repeat
		set total := total + n;
		set n := n - 1;
	until  n <= 0
	end repeat;
	select total;
end;

call p8(10);
call p8(100);
```

#### 4.2.11 loop

> LOOP 实现简单的循环，如果不在SQL逻辑中增加退出循环的条件，可以用其来实现简单的死循环。
>
> 搭配使用：
>
> - LEAVE ：配合循环使用，退出循环。
> - ITERATE：必须用在循环中，作用是跳过当前循环剩下的语句，直接进入下一次循环。

```mysql
[begin_label:]  LOOP
      SQL逻辑...
END LOOP [end_label];
```

```mysql
-- 退出指定标记的循环体
LEAVE label;
-- 直接进入下一次循环
ITERATE  label;
```

>begin_label，end_label，label 指的都是我们所自定义的标记。

案例一：

> 计算从1累加到n的值，n为传入的参数值。

```mysql
-- A. 定义局部变量, 记录累加之后的值;
-- B. 每循环一次, 就会对n进行-1 , 如果n减到0, 则退出循环 ----> leave xx

create procedure p9(in n int)
begin
	declare total int default 0;
	sum:loop
		if n<=0 then
			leave sum;
		end if;
		set total := total + n;
		set n := n - 1;
	end loop sum;
   select total;
   end; 
call p9(100);  
```

案例二：

> 计算从1到n之间的偶数累加的值，n为传入的参数值。

```mysql
-- A. 定义局部变量, 记录累加之后的值;
-- B. 每循环一次, 就会对n进行-1 , 如果n减到0, 则退出循环    ----> leave xx
-- C. 如果当次累加的数据是奇数, 则直接进入下一次循环. --------> iterate xx

create procedure p10(in n int)
begin
	declare total int default 0;
	sum:loop
		if n<=0 then
			leave sum;
		end if;
        
        if n%2 = 1 then
        	set n := n - 1;
        	iterate sum;
        end if;
        
        set total := total + n;
        set n := n - 1;
    end loop sum;
    select total;
end;
call p10(100);
```

#### 4.2.12 游标

> 游标（CURSOR）是用来存储查询结果集的数据类型，在存储过程和函数中可以使用游标对结果集进行循环的处理。游标的使用包括游标的声明、OPEN、FETCH和CLOSE，其语法分别如下。

声明游标：

```mysql
DECLARE 游标名称 CURSOR FOR 查询语句;
```

打开游标：

```mysql
OPEN 游标名称;
```

获取游标记录：

```mysql
FETCH 游标名称 INTO 变量 [变量] ;
```

关闭游标：

```mysql
CLOSE 游标名称;
```

案例：

>根据传入的参数uage，来查询用户表tb_user中，所有的用户年龄小于等于uage的用户姓名（name）和专业（profession），并将用户的姓名和专业插入到所创建的一张新表 (id,name,profession)中。

```mysql
-- 逻辑:
-- A. 声明游标, 存储查询结果集
-- B. 准备: 创建表结构
-- C. 开启游标
-- D. 获取游标中的记录
-- E. 插入数据到新表中
-- F. 关闭游标

create procedure p11(in uage int)
begin
	declare uname varchar(100);
	declare upro varchar(100);
	declare u_cursor cursor for select name,profession from tb_user where age <= uage;
	drop table if exists tb_user_pro;
	create table if not exists tb_user_pro(
        id int primary key auto_increment,
        name varchar(100),
        profession varchar(100)
   );
   open u_cursor;
   while true do
   		fetch u_cursor into uname,upro;
   		insert into tb_user_pro values (null, uname, upro);
   end while;
   close u_cursor;
   
end;
call p11(30);
```

>上述的存储过程，最终在调用的过程中，会报错，之所以报错是因为上面的while循环中，并没有退出条件。
>
>当游标的数据集获取完毕之后，再次获取数据，就会报错，从而终止了程序的执行。
>
>但是此时，tb_user_pro表结构及其数据都已经插入成功了，可以直接刷新表结构，检查表结构中的数据。
>
>上述的功能，虽然实现，但逻辑并不完善，而且程序执行完毕，获取不到数据，数据库还报错。     
>
>要解决这个问题，需要通过MySQL中提供的条件处理程序     Handler来解决。

#### 4.2.13 条件处理程序

>可以用来定义在流程控制结构执行过程中遇到问题时相应的处理步骤。

```mysql
DECLARE  handler_action  HANDLER FOR    condition_value [, condition_value] ... statement ;

handler_action 的取值：
	CONTINUE: 继续执行当前程序
	EXIT: 终止执行当前程序
	
condition_value 的取值：
	SQLSTATE  sqlstate_value: 状态码，如 02000
	SQLWARNING: 所有以01开头的SQLSTATE代码的简写
	NOT FOUND: 所有以02开头的SQLSTATE代码的简写
	SQLEXCEPTION: 所有没有被SQLWARNING 或 NOT FOUND捕获的SQLSTATE代码的简写
```

案例：

>完善上一节案例问题，根据传入的参数uage，来查询用户表tb_user中，所有的用户年龄小于等于uage的用户姓名 （name）和专业（profession），并将用户的姓名和专业插入到所创建的一张新表 (id,name,profession)中。

通过SQLSTATE指定具体的状态码

```mysql
-- 逻辑:
-- A. 声明游标, 存储查询结果集
-- B. 准备: 创建表结构
-- C. 开启游标
-- D. 获取游标中的记录
-- E. 插入数据到新表中
-- F. 关闭游标

create procedure p11(in uage int)
   begin
   declare uname varchar(100);
   declare upro varchar(100);       
   declare u_cursor cursor for select name,profession from tb_user where age <= uage;
   -- 声明条件处理程序 ： 当SQL语句执行抛出的状态码为02000时，将关闭游标u_cursor，并退出
   declare exit handler for SQLSTATE '02000' close u_cursor;
   
   drop table if exists tb_user_pro;
   create table if not exists tb_user_pro(
       id int primary key auto_increment,
       name varchar(100),
       profession varchar(100)
    );
    open u_cursor;
    while true do
    	fetch u_cursor into uname,upro;
    	insert into tb_user_pro values (null, uname, upro);
    end while;
    close u_cursor;
end;      
call p11(30);   
```

通过SQLSTATE的代码简写方式 NOT FOUND

02 开头的状态码，代码简写为 NOT FOUND

```mysql
create procedure p12(in uage int)
begin
	declare uname varchar(100);
	declare upro varchar(100);
	declare u_cursor cursor for select name,profession from tb_user where age <= 
uage;
	-- 声明条件处理程序 ： 当SQL语句执行抛出的状态码为02开头时，将关闭游标u_cursor，并退出
	declare exit handler for not found close u_cursor;
	
	drop table if exists tb_user_pro;
	create table if not exists tb_user_pro(
        id int primary key auto_increment,
        name varchar(100),
        profession varchar(100)
    );
    open u_cursor;
    while true do
    	fetch u_cursor into uname,upro;
    	insert into tb_user_pro values (null, uname, upro);
    end while;
    close u_cursor;
end;
call p12(30);
```

具体的错误状态码，可以参考官方文档：
https://dev.mysql.com/doc/refman/8.0/en/declare-handler.html
https://dev.mysql.com/doc/mysql-errors/8.0/en/server-error-reference.html

### 4.3 存储函数

> 存储函数是有返回值的存储过程，存储函数的参数只能是IN类型的。

```mysql
CREATE FUNCTION 存储函数名称 ([ 参数列表 ])
RETURNS  type  [characteristic ...]
BEGIN
       -- SQL语句
       RETURN ...;
 END ;
```

characteristic说明：

- DETERMINISTIC：相同的输入参数总是产生相同的结果
- NO SQL ：不包含 SQL 语句。
- READS SQL DATA：包含读取数据的语句，但不包含写入数据的语句。

案例：

> 计算从1累加到n的值，n为传入的参数值。

```mysql
create function fun1(n int)
   returns int deterministic
   begin
   		declare total int default 0;

       while n>0 do
 			set total := total + n;
           	set n := n - 1;
       end while;

       return total;
end;

select fun1(50);
```

在mysql8.0版本中binlog默认是开启的，一旦开启了，mysql就要求在定义存储过程时，需要指定characteristic特性，否则就会报如下错误：

>  DETERMINISTIG, NO SOL,orREADs SL DATAimnits dedaratonand bimanyloggingis emabled you *might* wantouse theles safe log bin tnust huncion creatorvariable)

### 4.4 触发器

>触发器是与表有关的数据库对象，指在insert/update/delete之前(BEFORE)或之后(AFTER)，触 
>发并执行触发器中定义的SQL语句集合。触发器的这种特性可以协助应用在数据库端确保数据的完整性, 日志记录, 数据校验等操作。
>
>使用别名OLD和NEW来引用触发器中发生变化的记录内容，这与其他的数据库是相似的。现在触发器还 只支持行级触发，不支持语句级触发。

| 触发器类型 | NEW 和 OLD                                           |
| ---------- | ---------------------------------------------------- |
| INSERT     | NEW 表示将要或者已经新增的数据                       |
| UPDATE     | OLD表示修改之前的数据，NEW表示将要或已经修改后的数据 |
| DELETE     | OLD表示将要或者已经删除的数据                        |

创建

```mysql
CREATE TRIGGER  trigger_name
BEFORE/AFTER INSERT/UPDATE/DELETE
ON tbl_name FOR EACH ROW -- 行级触发器
BEGIN
       trigger_stmt ;
END;
```

查看

```mysql
SHOW  TRIGGERS ;
```

删除

```mysql
 -- 如果没有指定 schema_name，默认为当前数据库。
DROP TRIGGER  [schema_name.]trigger_name ;
```

案例：

>通过触发器记录tb_user 表的数据变更日志，将变更日志插入到日志表user_logs中, 包含增加、修改、删除;

```mysql
-- 准备工作    : 日志表    user_logs
 create table user_logs(
     id int(11) not null auto_increment,
	 operation varchar(20) not null comment '操作类型, insert/update/delete',
     operate_time datetime not null comment '操作时间',
     operate_id int(11) not null comment '操作的ID',
     operate_params varchar(500) comment '操作参数',
     primary key(`id`)
)engine=innodb default charset=utf8;
```

> 插入数据触发器

```mysql
create trigger tb_user_insert_trigger
       after insert on tb_user for each row
   begin
       insert into user_logs(id, operation, operate_time, operate_id, operate_params) 
VALUES(null, 'insert', now(), new.id, concat('插入的数据内容为:
id=',new.id,',name=',new.name, ', phone=', NEW.phone, ', email=', NEW.email, ', profession=', NEW.profession));
end;
```

测试

```mysql
-- 查看
show triggers ;

-- 插入数据到tb_user
insert into tb_user(id, name, phone, email, profession, age, gender, status,createtime) VALUES (26,'三皇子','18809091212','erhuangzi@163.com','软件工 程',23,'1','1',now());
```

> 修改数据触发器

```mysql
create trigger tb_user_update_trigger
       after update on tb_user for each row
   begin
       insert into user_logs(id, operation, operate_time, operate_id, operate_params) 
VALUES(null, 'update', now(), new.id, concat('更新之前的数据: id=',old.id,',name=',old.name, ', phone=', old.phone, ', email=', old.email, ',profession=', old.profession,' | 更新之后的数据: id=',new.id,',name=',new.name, ', phone=', NEW.phone, ', email=', NEW.email, ',profession=', NEW.profession));
end;
```

测试

```mysql
-- 查看
show triggers ;

-- 更新
update tb_user set profession = '会计' where id = 23;
update tb_user set profession = '会计' where id <= 5;
```

> 删除数据触发器

```mysql
create trigger tb_user_delete_trigger
       after delete on tb_user for each row
   begin
       insert into user_logs(id, operation, operate_time, operate_id, operate_params) 
VALUES(null, 'delete', now(), old.id,concat('删除之前的数据: id=',old.id,',name=',old.name, ', phone=',old.phone, ', email=', old.email, ', profession=', old.profession));
end;
```

测试

```mysql
-- 查看
show triggers ;

-- 删除数据
delete from tb_user where id = 26;
```

## 5. 锁

>锁是计算机协调多个进程或线程并发访问某一资源的机制。在数据库中，除传统的计算资源（CPU、RAM、I/O）的争用以外，数据也是一种供许多用户共享的资源。如何保证数据并发访问的一致性、有效性是所有数据库必须解决的一个问题，锁冲突也是影响数据库并发访问性能的一个重要因素。从这个角度来说，锁对数据库而言显得尤其重要，也更加复杂。

`针对事务才有加锁的意义`

按照锁的粒度分三类：

- 全局锁：锁定数据库中的所有表。
- 表级锁：每次操作锁住整张表。
- 行级锁：每次操作锁住对应的行数据。

### 5.1 全局锁

>全局锁就是对整个数据库实例加锁，加锁后整个实例就处于只读状态，后续的DML的写语句，DDL语句，已经更新操作的事务提交语句都将被阻塞。
>其典型的使用场景是做全库的逻辑备份，对所有的表进行锁定，从而获取一致性视图，保证数据的完整性。  

- 加全局锁

  ```mysql
  flush tables with read lock ;
  ```

- 数据备份

  ```mysql
  mysqldump -uroot –p123456  test > test.sql
  ```

- 释放锁

  ```mysql
  unlock tables;
  ```

特点：

数据库中加全局锁，是一个比较重的操作，存在以下问题：

- 如果在主库上备份，那么在备份期间都不能执行更新，业务基本上就得停摆。

- 如果在从库上备份，那么在备份期间从库不能执行主库同步过来的二进制日志（binlog），会导致主从延迟。

在InnoDB引擎中，我们可以在备份时加上参数--single-transaction 参数来完成不加锁的一致性数据备份。

```mysql
mysqldump --single-transaction  -uroot –p123456  test > test.sql
```

### 5.2 表级锁

>每次操作锁住整张表。锁定粒度大，发生锁冲突的概率最高，并发度最低。应用在MyISAM、InnoDB、BDB等存储引擎中。

表级锁，主要分为以下三类：

- 表锁
- 元数据锁（meta data lock，MDL） 
- 意向锁

#### 5.2.1 表锁

分为两类：

- 表共享读锁（read lock） 
- 表独占写锁（write lock）

语法：

- 加锁：lock tables 表名... read/write。 
- 释放锁：unlock tables / 客户端断开连接。

特点：

读锁

>对指定表加了读锁，不会影响右侧客户端二的读，但是会阻塞右侧客户端的写。

写锁

>对指定表加了写锁，会阻塞右侧客户端的读和写。

总结：

>读锁不会阻塞其他客户端的读，但是会阻塞写。写锁既会阻塞其他客户端的读，又会阻塞 其他客户端的写。

#### 5.2.2 元数据锁

> meta data lock , 元数据锁，简写MDL。
>
> MDL加锁过程是系统自动控制，无需显式使用，在访问一张表的时候会自动加上。MDL锁主要作用是维护表元数据的数据一致性，在表上有活动事务的时候，不可以对元数据进行写入操作。 为了避免DML与DDL冲突，保证读写的正确性。
>
> - 元数据 -> 一张表结构
>
> - 某表涉及到未提交的事务时，不能修改这表的表结构。
>
> 在MySQL5.5中引入了MDL，当对一张表进行增删改查的时候，加MDL读锁(共享)；当对表结构进行变更操作的时候，加MDL写锁(排他)。

常见的SQL操作时，所添加的元数据锁：

| 对应SQL                                         | 锁类型                                  | 说明                                               |
| ----------------------------------------------- | --------------------------------------- | -------------------------------------------------- |
| lock tables xxx read / write                    | SHARED_READ_ONLY / SHARED_NO_READ_WRITE |                                                    |
| select 、select ... lock in share mode          | SHARED_READ                             | 与SHARED_READ、 SHARED_WRITE兼容，与 EXCLUSIVE互斥 |
| insert 、update、 delete、select ... for update | SHARED_WRITE                            | 与SHARED_READ、 SHARED_WRITE兼容，与 EXCLUSIVE互斥 |
| alter table ...                                 | EXCLUSIVE                               | 与其他的MDL都互斥                                  |

> 通过下面的SQL，来查看数据库中的元数据锁的情况：
>
> ```mysql
> select object_type,object_schema,object_name,lock_type,lock_duration from performance_schema.metadata_locks ;
> ```
>
> 看 object_name 和 lock_type

#### 5.2.3 意向锁

>为了避免DML在执行时，加的行锁与表锁的冲突，在InnoDB中引入了意向锁，使得表锁不用检查每行数据是否加锁，使用意向锁来减少表锁的检查。

分类：

- 意向共享锁(IS): 由语句select ... lock in share mode添加。与表锁共享锁(read)兼容，与表锁排他锁(write)互斥。
- 意向排他锁(IX): 由insert、update、delete、select...for update添加。与表锁共享锁(read)及排他锁(write)都互斥，意向锁之间不会互斥。

>一旦事务提交了，意向共享锁、意向排他锁，都会自动释放。

通过以下SQL，查看意向锁及行锁的加锁情况：

```mysql
select object_schema,object_name,index_name,lock_type,lock_mode,lock_data from performance_schema.data_locks;
```

### 5.3 行级锁

>行级锁，每次操作锁住对应的行数据。锁定粒度最小，发生锁冲突的概率最低，并发度最高。应用在InnoDB存储引擎中。

InnoDB的数据是基于索引组织的，行锁是通过对索引上的索引项加锁来实现的，而不是对记录加的锁。对于行级锁，主要分为以下三类：

- 行锁（Record Lock）：锁定单个行记录的锁，防止其他事务对此行进行update和delete。在RC、RR隔离级别下都支持。
- 间隙锁（Gap Lock）：锁定索引记录间隙（不含该记录），确保索引记录间隙不变，防止其他事务在这个间隙进行insert，产生幻读。在RR隔离级别下都支持。
- 临键锁（Next-Key Lock）：行锁和间隙锁组合，同时锁住数据，并锁住数据前面的间隙Gap。在RR隔离级别下支持。

#### 5.3.1 行锁

InnoDB实现了以下两种类型的行锁：

- 共享锁（S）：允许一个事务去读一行，阻止其他事务获得相同数据集的排它锁。
- 排他锁（X）：允许获取排他锁的事务更新数据，阻止其他事务获得相同数据集的共享锁和排他 
  锁。

兼容情况：

| 请求锁类型/当前锁类型 | S（共享锁） | X（排它锁） |
| --------------------- | ----------- | ----------- |
| S（共享锁）           | 兼容        | 冲突        |
| X（排它锁）           | 冲突        | 冲突        |

常见的SQL语句，在执行时，所加的行锁如下：

| SQL                           | 行锁类型   | 说明                                     |
| ----------------------------- | ---------- | ---------------------------------------- |
| INSERT ...                    | 排他锁     | 自动加锁                                 |
| UPDATE ...                    | 排他锁     | 自动加锁                                 |
| DELETE ...                    | 排他锁     | 自动加锁                                 |
| SELECT（正常）                | 不加任何锁 |                                          |
| SELECT ... LOCK IN SHARE MODE | 共享锁     | 需要手动在SELECT之后加LOCK IN SHARE MODE |
| SELECT ... FOR UPDATE         | 排他锁     | 需要手动在SELECT之后加FOR UPDATE         |

默认情况下，InnoDB在 REPEATABLE READ事务隔离级别运行，InnoDB使用next-key 锁进行搜索和索引扫描，以防止幻读。

- 针对唯一索引进行检索时，对已存在的记录进行等值匹配时，将会自动优化为行锁。
- InnoDB的行锁是针对于索引加的锁，不通过索引条件检索数据，那么InnoDB将对表中的所有记录加锁，此时就会升级为表锁。

通过以下SQL，查看意向锁及行锁的加锁情况：

```mysql
select object_schema,object_name,index_name,lock_type,lock_mode,lock_data from performance_schema.data_locks;
```

示例：

```mysql
CREATE TABLE `stu`  (
 `id` int NOT NULL PRIMARY KEY AUTO_INCREMENT,
    `name` varchar(255) DEFAULT NULL,
    `age` int NOT NULL
) ENGINE = InnoDB CHARACTER SET = utf8mb4;

INSERT INTO `stu` VALUES (1, 'tom', 1);
INSERT INTO `stu` VALUES (3, 'cat', 3);
INSERT INTO `stu` VALUES (8, 'rose', 8);
INSERT INTO `stu` VALUES (11, 'jetty', 11);
INSERT INTO `stu` VALUES (19, 'lily', 19);
INSERT INTO `stu` VALUES (25, 'luci', 25);


-- 普通的select语句，执行时，不会加锁
# 客户端一
select * from stu where id =1;
# 客户端二
select object_schema,object_name,index_name,lock_type,lock_mode,lock_data from performance_schema.data_locks;

-- select...lock in share mode，加共享锁，共享锁与共享锁之间兼容。
# 客户端一
select * from stu where id =1 lock in share mode;
# 客户端二
select object_schema,object_name,index_name,lock_type,lock_mode,lock_data from performance_schema.data_locks;

-- 共享锁与排他锁之间互斥。
#客户端一获取的是id为1这行的共享锁
select * from stu where id =1 lock in share mode;
# 客户端二是可以获取id为3这行的排它锁的，因为不是同一行数据。而如果客户端二想获取id为1这行的排他锁，会处于阻塞状态，以为共享锁与排他锁之间互斥。
update stu set name = 'Java' where id = 3;
update stu set name = 'Java' where id = 1;

-- 排它锁与排他锁之间互斥
#客户端一
update stu set name = 'Java' where id = 1;
# 客户端二
update stu set name = 'Java' where id = 1;
# 当客户端一，执行update语句，会为id为1的记录加排他锁； 客户端二，如果也执行update语句更新id为1的数据，也要为id为1的数据加排他锁，但是客户端二会处于阻塞状态，因为排他锁之间是互斥的。 直到客户端一，把事务提交了，才会把这一行的行锁释放，此时客户端二，解除阻塞。

-- 无索引行锁升级为表锁
#客户端一
update stu set name = 'Lei' where name = 'Lily';
# 客户端二
update stu set name = 'PHP' where id = 3;
# 在客户端一中，开启事务，并执行update语句，更新name为Lily的数据，也就是id为19的记录。 然后在客户端二中更新id为3的记录，却不能直接执行，会处于阻塞状态，为什么呢？
#原因就是因为此时，客户端一，根据name字段进行更新时，name字段是没有索引的，如果没有索引，此时行锁会升级为表锁(因为行锁是对索引项加的锁，而name没有索引)。

-- 针对name字段建立索引，索引建立之后。
#客户端一
create index idx_stu_name on stu(name);
begin;
update stu set name = 'Lily' where name = 'Lei';
# 客户端二
update stu set name = 'PHP' where id = 3;
# 客户端一，开启事务，然后依然是根据name进行更新。而客户端二，在更新id为3的数据时，更新成功，并未进入阻塞状态。根据索引字段进行更新操作，就可以避免行锁升级为表锁的情况。
```

#### 5.3.2 间隙锁&临键锁

>默认情况下，InnoDB在REPEATABLE READ事务隔离级别运行，InnoDB使用next-key 锁进行搜索和索引扫描，以防止幻读。

- 索引上的等值查询(唯一索引)，给不存在的记录加锁时, 优化为间隙锁。
- 索引上的等值查询(非唯一普通索引)，向右遍历时最后一个值不满足查询需求时，next-key lock 退化为间隙锁。
- 索引上的范围查询(唯一索引)--会访问到不满足条件的第一个值为止。

>间隙锁唯一目的是防止其他事务插入间隙。间隙锁可以共存，一个事务采用的间隙锁不会阻止另一个事务在同一间隙上采用间隙锁。

示例:

```mysql
-- 索引上的等值查询(唯一索引)，给不存在的记录加锁时, 优化为间隙锁。
# 客户端一
begin;
update stu set age = 10 where id =5;
# 客户端二 由于把8之前的间隙锁住了，不能插入id为7的数据
select object_schema,object_name,index_name,lock_type,lock_mode,lock_data from performance_schema.data_locks;

insert into stu values(7,'Ruby',7)

-- 索引上的等值查询(非唯一普通索引)，向右遍历时最后一个值不满足查询需求时，next-key lock 退化为间隙锁。
# 分析InnoDB的B+树索引，叶子节点是有序的双向链表。 假如，我们要根据这个二级索引查询值为18的数据，并加上共享锁，我们是只锁定18这一行就可以了吗？ 并不是，因为是非唯一索引，这个结构中可能有多个18的存在，所以，在加锁时会继续往后找，找到一个不满足条件的值（当前案例中也就是29）。此时会对18加临键锁，并对29之前的间隙加锁。
# 客户端一
create index idx_stu_age on stu(age);
begin;
select * from stu where age = 3 lock in share mode;
# 客户端二
select object_schema,object_name,index_name,lock_type,lock_mode,lock_data from performance_schema.data_locks;

-- 索引上的范围查询(唯一索引)--会访问到不满足条件的第一个值为止。
# 客户端一
begin;
select * from stu where id >=19 lock in share mode;
# 客户端二
select object_schema,object_name,index_name,lock_type,lock_mode,lock_data from performance_schema.data_locks;
# 查询的条件为id>=19，并添加共享锁。此时我们可以根据数据库表中现有的数据，将数据分为三个部分：
# [19] 
#(19,25] 
#(25,+∞]
# 所以数据库数据在加锁是，就是将19加了行锁，25的临键锁（包含25及25之前的间隙），正无穷的临键锁(正无穷及之前的间隙)。
```

## 6. InnoDB引擎

### 6.1 逻辑存储结构

![image-20241007152352297](image\image-20241007152352297.png)

- 表空间

>表空间是InnoDB存储引擎逻辑结构的最高层，如果用户启用了参数 innodb_file_per_table(在8.0版本中默认开启) ，则每张表都会有一个表空间（xxx.ibd），一个mysql实例可以对应多个表空间，用于存储记录、索引等数据。

- 段

>分为数据段（Leaf node segment）、索引段（Non-leaf node segment）、回滚段（Rollback segment），InnoDB是索引组织表，数据段就是B+树的叶子节点，索引段即为B+树的非叶子节点。段用来管理多个Extent（区）。

- 区

>表空间的单元结构，每个区的大小为1M。默认情况下，     InnoDB存储引擎页大小为16K，即一个区中一共有64个连续的页。

- 页

>InnoDB 存储引擎磁盘管理的最小单元，每个页的大小默认为     16KB。为了保证页的连续性，InnoDB 存储引擎每次从磁盘申请4-5 个区。

- 行

> InnoDB 存储引擎数据是按行进行存放的。
>
> 两个隐藏字段：
>
> - Trx_id：每次对某条记录进行改动时，都会把对应的事务id赋值给trx_id隐藏列。
> - Roll_pointer：每次对某条引记录进行改动时，都会把旧的版本写入到undo日志中，然后这个 
>   隐藏列就相当于一个指针，可以通过它来找到该记录修改前的信息。

### 6.2 架构

>MySQL5.5 版本开始，默认使用InnoDB存储引擎，它擅长事务处理，具有崩溃恢复特性，在日常开发中使用非常广泛。下面是InnoDB架构图，左侧为内存结构，右侧为磁盘结构。

![image-20241007153123210](image\image-20241007153123210.png)

#### 6.2.1 内存结构

![image-20241007153408791](image\image-20241007153408791.png)

> 在左侧的内存结构中，主要分为这么四大块儿：     Buffer Pool、Change Buffer、Adaptive Hash Index、Log Buffer。

- Buffer Pool

>InnoDB存储引擎基于磁盘文件存储，访问物理硬盘和在内存中进行访问，速度相差很大，为了尽可能弥补这两者之间的I/O效率的差值，就需要把经常使用的数据加载到缓冲池中，避免每次访问都进行磁盘I/O。

> 在InnoDB的缓冲池中不仅缓存了索引页和数据页，还包含了undo页、插入缓存、自适应哈希索引以及InnoDB的锁信息等等。

>缓冲池 Buffer Pool，是主内存中的一个区域，里面可以缓存磁盘上经常操作的真实数据，在执行增删改查操作时，先操作缓冲池中的数据（若缓冲池没有数据，则从磁盘加载并缓存），然后再以一定频率刷新到磁盘，从而减少磁盘IO，加快处理速度。

缓冲池以Page页为单位，底层采用链表数据结构管理Page。根据状态，将Page分为三种类型：
• free page：空闲page，未被使用。
• clean page：被使用page，数据没有被修改过。
• dirty page：脏页，被使用page，数据被修改过，其中数据与磁盘的数据产生了不一致。

在专用服务器上，通常将多达80％的物理内存分配给缓冲池。参数设置：

```mysql
show variables like 'innodb_buffer_pool_size';
```

- Change Buffer

Change Buffer，更改缓冲区（针对于非唯一二级索引页），在执行DML语句时，如果这些数据Page没有在Buffer Pool中，不会直接操作磁盘，而会将数据变更存在更改缓冲区     Change Buffer中，在未来数据被读取时，再将数据合并恢复到Buffer Pool中，再将合并后的数据刷新到磁盘中。

Change Buffer的意义?

二级索引的结构图：

![image-20241007154948945](image\image-20241007154948945.png)

> 与聚集索引不同，二级索引通常是非唯一的，并且以相对随机的顺序插入二级索引。同样，删除和更新可能会影响索引树中不相邻的二级索引页，如果每一次都操作磁盘，会造成大量的磁盘IO。有了ChangeBuffer之后，我们可以在缓冲池中进行合并处理，减少磁盘IO

- Adaptive Hash Index

> 自适应hash索引，用于优化对Buffer Pool数据的查询。MySQL的innoDB引擎中虽然没有直接支持 hash索引，但是给我们提供了一个功能就是这个自适应hash索引。因为前面我们讲到过，hash索引在进行等值匹配时，一般性能是要高于B+树的，因为hash索引一般只需要一次IO即可，而B+树，可能需要几次匹配，所以hash索引的效率要高，但是hash索引又不适合做范围查询、模糊匹配等。

> InnoDB存储引擎会监控对表上各索引页的查询，如果观察到在特定的条件下hash索引可以提升速度，则建立hash索引，称之为自适应hash索引。

> 自适应哈希索引，无需人工干预，系统根据情况自动完成。
>
> 参数：adaptive_hash_index

- Log Buffer
  Log Buffer：日志缓冲区，用来保存要写入到磁盘中的log日志数据（redo log 、undo log），默认大小为     16MB，日志缓冲区的日志会定期刷新到磁盘中。如果需要更新、插入或删除许多行的事务，增加日志缓冲区的大小可以节省磁盘I/O。

参数：

innodb_log_buffer_size：缓冲区大小
innodb_flush_log_at_trx_commit：日志刷新到磁盘时机，取值主要包含以下三个：

- 日志在每次事务提交时写入并刷新到磁盘，默认值。
- 每秒将日志写入并刷新到磁盘一次。
- 日志在每次事务提交后写入，并每秒刷新到磁盘一次。

#### 6.2.2 磁盘结构

> InnoDB体系结构的右边部分，也就是磁盘结构：

![image-20241007155827785](image\image-20241007155827785.png)

- System Tablespace

> 系统表空间是更改缓冲区的存储区域。如果表是在系统表空间而不是每个表文件或通用表空间中创建的，它也可能包含表和索引数据。(在MySQL5.x版本中还包含InnoDB数据字典、undolog等)

参数：innodb_data_file_path

系统表空间，默认的文件名叫 ibdata1。

- File-Per-Table Tablespaces

> 如果开启了innodb_file_per_table开关，则每个表的文件表空间包含单个InnoDB表的数据和索引，并存储在文件系统上的单个数据文件中。

开关参数：innodb_file_per_table ，该参数默认开启。

> 每创建一个表，会产生一个表空间文件

- General Tablespaces
  通用表空间，需要通过CREATE TABLESPACE 语法创建通用表空间，在创建表时，可以指定该表空间。

  - 创建表空间

    ```mysql
    CREATE TABLESPACE ts_name  ADD  DATAFILE 'file_name' ENGINE = engine_name;
    ```

  - 创建表时指定表空间

    ```mysql
    CREATE  TABLE  xxx ...  TABLESPACE  ts_name;
    ```

- Undo Tablespaces

  > 撤销表空间，MySQL实例在初始化时会自动创建两个默认的undo表空间（初始大小16M），用于存储undo log日志。

- Temporary Tablespaces

  > InnoDB 使用会话临时表空间和全局临时表空间。存储用户创建的临时表等数据。

- Doublewrite Buffer Files

  >双写缓冲区，innoDB引擎将数据页从Buffer Pool刷新到磁盘前，先将数据页写入双写缓冲区文件中，便于系统异常时恢复数据。
  >
  >(#ib_16380_0.dblwr、#ib_16380_1.dblwr)

- Redo Log

  > 重做日志，是用来实现事务的持久性。该日志文件由两部分组成：重做日志缓冲（redo log buffer）以及重做日志文件（redo log）,前者是在内存中，后者在磁盘中。当事务提交之后会把所有修改信息都会存到该日志中, 用于在刷新脏页到磁盘时,发生错误时, 进行数据恢复使用。以循环方式写入重做日志文件，涉及两个文件：
  >
  > (ib_logfile0、ib_logfile1)

  InnoDB的内存结构，以及磁盘结构，那么内存中所更新的数据，如何到磁盘中？

  涉及到一组后台线程。

![image-20241007161439447](image\image-20241007161439447.png)

#### 6.2.3 后台线程

![image-20241007161541835](image\image-20241007161541835.png)

在InnoDB的后台线程中，分为4类，分别是：

Master Thread、IO Thread、Purge Thread、 
Page Cleaner Thread。

- Master Thread
  核心后台线程，负责调度其他线程，还负责将缓冲池中的数据异步刷新到磁盘中, 保持数据的一致性，还包括脏页的刷新、合并插入缓存、undo页的回收。
- IO Thread
  在InnoDB存储引擎中大量使用了AIO来处理IO请求, 这样可以极大地提高数据库的性能，而IO Thread主要负责这些IO请求的回调。

| 线程类型             | 默认个数 | 职责                         |
| -------------------- | -------- | ---------------------------- |
| Read thread          | 4        | 负责读操作                   |
| Write thread         | 4        | 负责写操作                   |
| Log thread           | 1        | 负责将日志缓冲区刷新到磁盘   |
| Insert buffer thread | 1        | 负责将写缓冲区内容刷新到磁盘 |

查看InnoDB的状态信息，其中包含IO Thread信息。

```mysql
show engine innodb status \G;
```

- Purge Thread
  主要用于回收事务已经提交了的undo log，在事务提交之后，undo log可能不用了，就用它来回收。

- Page Cleaner Thread
  协助Master Thread 刷新脏页到磁盘的线程，它可以减轻     Master Thread 的工作压力，减少阻塞。

### 6.3 事务原理

- 事务

>一组操作的集合，它是一个不可分割的工作单位，事务会把所有的操作作为一个整体一起向系统提交或撤销操作请求，即这些操作要么同时成功，要么同时失败。

- 特性

>原子性（Atomicity）：事务是不可分割的最小操作单元，要么全部成功，要么全部失败。
>• 一致性（Consistency）：事务完成时，必须使所有的数据都保持一致状态。
>• 隔离性（Isolation）：数据库系统提供的隔离机制，保证事务在不受外部并发操作影响的独立环境下运行。
>• 持久性（Durability）：事务一旦提交或回滚，它对数据库中的数据的改变就是永久的。

研究事务的原理，就是研究MySQL的InnoDB引擎是如何保证事务的这四大特性。

四大特性，分为两个部分。其中的原子性、一致性、持久化，实际上是由InnoDB中的两份日志来保证的，一份是redo log日志，一份是undo log日志。 而持久性是通过数据库的锁， 
加上MVCC来保证。

![image-20241007162603454](image\image-20241007162603454.png)

> 事务原理主要是研究redolog，undolog以及MVCC。

#### 6.3.1 redo log

重做日志，记录的是事务提交时数据页的物理修改，是用来实现事务的持久性。

分为两种：

- 重做日志缓冲（redo log buffer）
- 重做日志文件（redo log file）

> 前者是在内存中，后者在磁盘中。当事务提交之后会把所有修改信息都存到该日志文件中, 用于在刷新脏页到磁盘,发生错误时, 进行数据恢复使用。

如果没有redolog，可能会存在什么问题的？

>在InnoDB引擎中的内存结构中，主要的内存区域就是缓冲池，在缓冲池中缓存了很多的数据页。当一个事务中执行多个增删改的操作时，InnoDB引擎会先操作缓冲池中的数据，如果缓冲区没有对应的数据，会通过后台线程将磁盘中的数据加载出来，存放在缓冲区中，然后将缓冲池中的数据修改，修改后的数据页我们称为脏页。而脏页则会在一定的时机，通过后台线程刷新到磁盘中，从而保证缓冲区与磁盘的数据一致。而缓冲区的脏页数据并不是实时刷新的，而是一段时间之后将缓冲区的数据刷新到磁盘中，假如刷新到磁盘的过程出错了，而提示给用户事务提交成功，而数据却没有持久化下来，这就出现问题了，没有保证事务的持久性。

![image-20241007233514258](image\image-20241007233514258.png)解决上述的问题？     

在InnoDB中提供了一份日志redo log

![image-20241007233600438](image\image-20241007233600438.png)

>有了redolog之后，当对缓冲区的数据进行增删改之后，会首先将操作的数据页的变化，记录在redo log buffer中。在事务提交时，会将redo log buffer中的数据刷新到redo log磁盘文件中。过一段时间之后，如果刷新缓冲区的脏页到磁盘时，发生错误，此时就可以借助于redo log进行数据 
>恢复，这样就保证了事务的持久性。而如果脏页成功刷新到磁盘或或者涉及到的数据已经落盘，此时redo log就没有作用了，就可以删除了，所以存在的两个redo log文件是循环写的。

那为什么每一次提交事务，要刷新redo log到磁盘中呢，而不是直接将buffer pool中的脏页刷新到磁盘?

>因为在业务操作中，操作数据一般都是随机读写磁盘，而不是顺序读写磁盘。 而redo log在往磁盘文件中写入数据，由于是日志文件，所以都是顺序写的。顺序写的效率，要远大于随机写。 这种先写日志的方式，称之为 WAL（Write-Ahead Logging）。

#### 6.3.2 undo log

回滚日志，用于记录数据被修改前的信息。

作用: 

- 提供回滚(保证事务的原子性)
- MVCC(多版本并发控制)

undo log和redo log记录物理日志不一样，它是逻辑日志。可以认为当delete一条记录时，undo log中会记录一条对应的insert记录。

反之亦然，当update一条记录时，它记录一条对应相反的 
update记录。当执行rollback时，就可以从undo log中的逻辑记录读取到相应的内容并进行回滚。

> Undo log销毁：undo log在事务执行时产生，事务提交时，并不会立即删除undo log，因为这些 日志可能还用于MVCC。

>Undo log存储：undo log采用段的方式进行管理和记录，存放在前面介绍的rollback segment 回滚段中，内部包含1024个undo log segment。

### 6.4 MVCC

- 当前读

> 读取的是记录的最新版本，读取时还要保证其他并发事务不能修改当前记录，会对读取的记录进行加锁。对于我们日常的操作，如：select ... lock in share mode(共享锁)，select ... for update、update、insert、delete(排他锁)都是一种当前读。

测试：

```mysql
# 客户端一
begin；
select * from stu;
# 客户端二
begin;
update stu set name = "Jsp" where id = 1;
commit;
# 客户端一
select * from stu lock in share mode;
# 事务B已提交的数据马上能查询到
```

>即使是在默认的RR隔离级别下，事务A中依然可以读取到事务B最新提交的内容，因为在查询语句后面加上了 lock in share mode 共享锁，此时是当前读操作。当然，当我们 
>加排他锁的时候，也是当前读操作。

- 快照读

> 简单的select（不加锁）就是快照读，快照读，读取的是记录数据的可见版本，有可能是历史数据， 
> 不加锁，是非阻塞读。
> 	• Read Committed：每次select，都生成一个快照读。
> 	• Repeatable Read：开启事务后第一个select语句才是快照读的地方。
> 	• Serializable：快照读会退化为当前读。

```mysql
# 客户端一
begin；
select * from stu;
# 客户端二
begin;
update stu set name = "Jsp" where id = 1;
commit;
# 客户端一
select * from stu;
# 事务B已提交的数据,在事务A查询不到
```

>即使事务B提交了数据,事务A中也查询不到。 
>
>> 原因就是普通的select是快照读，而在当前默认的RR隔离级别下，开启事务后第一个select语句才是快照读的地方，后面执行相同的select语句都是从快照中获取数据，可能不是当前的最新数据，这样也就保证了可重复读。

- MVCC

> 全称 Multi-Version Concurrency Control，多版本并发控制。指维护一个数据的多个版本，使得读写操作没有冲突，快照读为MySQL实现MVCC提供了一个非阻塞读功能。MVCC的具体实现，还需要依赖于数据库记录中的三个隐式字段、undo log日志、readView。

#### 6.4.1 隐藏字段

| id   | name | age  |
| ---- | ---- | ---- |
| 1    | tom  | 20   |
| 6    | cat  | 21   |

>在查看表结构时，可以显式的看到这三个字段。     
>
>实际上除了这三个字段以外，InnoDB会自动添加三个隐藏字段及其含义分别是：

| 隐藏字段    | 含义                                                         |
| ----------- | ------------------------------------------------------------ |
| DB_TRX_ID   | 最近修改事务ID，记录插入这条记录或最后一次修改该记录的事务ID。 |
| DB_ROLL_PTR | 回滚指针，指向这条记录的上一个版本，用于配合undo log，指向上一个版本。 |
| DB_ROW_ID   | 隐藏主键，如果表结构没有指定主键，将会生成该隐藏字段。       |

>前两个字段一定会添加，最后一个字段DB_ROW_ID，得看当前表有没有主键，如果有主键，则不会添加该隐藏字段。

测试：

-  查看有主键的表stu

进入服务器中的/var/lib/mysql/test/ , 查看stu的表结构信息, 通过如下指令:

```mysql
ibd2sdi stu.ibd
```

> 表结构信息中，有一栏 columns，在其中看到建表时指定的字段以外，还有额外的两个字段 分别是：DB_TRX_ID 、 DB_ROLL_PTR，因为该表有主键，所以没有DB_ROW_ID 
> 隐藏字段。

- 查看没有主键的表employee

```mysql
-- 创建无主键表
create table employee (id int , name varchar(10));

-- 查看表结构及其中的字段信息
ibd2sdi employee.ibd
```

>表结构信息中，有一栏 columns，在其中看到建表时指定的字段以外，还有额外的三个字段 分别是：DB_TRX_ID 、 DB_ROLL_PTR 、DB_ROW_ID，因为employee表没有 
>指定主键。

#### 6.4.2 undolog

回滚日志

> 在insert、update、delete时产生数据回滚的日志。
> 当insert的时候，产生的undo log日志只在回滚时需要，在事务提交后，可被立即删除。
> 而update、delete的时候，产生的undo log日志不仅在回滚时需要，在快照读时也需要，不会立即被删除。

- 版本链

| id   | age  | name | DB_TRX_ID | DB_ROLL_PTR |
| ---- | ---- | ---- | --------- | ----------- |
| 30   | 30   | A30  | 1         | null        |

>DB_TRX_ID : 代表最近修改事务ID，记录插入这条记录或最后一次修改该记录的事务ID，是自增的。
>DB_ROLL_PTR ：由于这条数据是才插入的，没有被更新过，所以该字段值为null。

然后，有四个并发事务同时在访问这张表。 
A. 第一步

![image-20241008001038762](image\image-20241008001038762.png)

当事务2执行第一条修改语句时，会记录undo log日志，记录数据变更之前的样子; 然后更新记录，并且记录本次操作的事务ID，回滚指针，回滚指针用来指定如果发生回滚，回滚到哪一个版本。

![image-20241008001124774](image\image-20241008001124774.png)

B.第二步

![image-20241008001155681](image\image-20241008001155681.png)

当事务3执行第一条修改语句时，也会记录undo log日志，记录数据变更之前的样子; 然后更新记录，并且记录本次操作的事务ID，回滚指针，回滚指针用来指定如果发生回滚，回滚到哪一个版本。

![image-20241008001240954](image\image-20241008001240954.png)

C. 第三步

![image-20241008001340615](image\image-20241008001340615.png)

当事务4执行第一条修改语句时，也会记录undo log日志，记录数据变更之前的样子; 然后更新记录，并且记录本次操作的事务ID，回滚指针，回滚指针用来指定如果发生回滚，回滚到哪一个版本。

![image-20241008001419413](image\image-20241008001419413.png)

>不同事务或相同事务对同一条记录进行修改，会导致该记录的undolog生成一条记录版本链表，链表的头部是最新的旧记录，链表尾部是最早的旧记录。

#### 6.4.3 readview

> ReadView（读视图）是快照读SQL执行时MVCC提取数据的依据，记录并维护系统当前活跃的事务（未提交的）id。

四个核心字段：

| 字段           | 含义                                                 |
| -------------- | ---------------------------------------------------- |
| m_ids          | 当前活跃的事务ID集合                                 |
| min_trx_id     | 最小活跃事务ID                                       |
| max_trx_id     | 预分配事务ID，当前最大事务ID+1（因为事务ID是自增的） |
| creator_trx_id | ReadView创建者的事务ID                               |

而在readview中就规定了版本链数据的访问规则：

trx_id 代表当前undolog版本链对应事务ID。

| 条件                                                         | 是否可以访问                              | 说明                                        |
| ------------------------------------------------------------ | ----------------------------------------- | ------------------------------------------- |
| trx_id == creator_trx_id 预分配事务ID，当前最大事务ID+1（因为事务ID是自增的） | 可以访问该版本                            | 成立，说明数据是当前这个事务更改的。        |
| trx_id < min_trx_id                                          | 可以访问该版本                            | 成立，说明数据已经提交了。                  |
| trx_id > max_trx_id                                          | 不可以访问该版本                          | 成立，说明该事务是在 ReadView生成后才开启。 |
| min_trx_id <= trx_id <= max_trx_id                           | 如果trx_id不在m_ids中，是可以访问该版本的 | 成立，说明数据已经提交。                    |

不同的隔离级别，生成ReadView的时机不同：

- READ COMMITTED ：在事务中每一次执行快照读时生成ReadView。
- REPEATABLE READ：仅在事务中第一次执行快照读时生成ReadView，后续复用该ReadView。

#### 6.4.4 原理分析

##### 6.4.4.1 RC隔离级别

RC隔离级别下，在事务中每一次执行快照读时生成ReadView。

> 分析事务5中，两次快照读读取数据，是如何获取数据?

在事务5中，查询了两次id为30的记录，由于隔离级别为Read Committed，所以每一次进行快照读都会生成一个ReadView，那么两次生成的ReadView如下。

![image-20241008003051579](image\image-20241008003051579.png)

那么这两次快照读在获取数据时，就需要根据所生成的ReadView以及ReadView的版本链访问规则，到undolog版本链中匹配数据，最终决定此次快照读返回的数据。

A. 先来看第一次快照读具体的读取过程：

![image-20241008003151260](image\image-20241008003151260.png)

![image-20241008003220660](image\image-20241008003220660.png)

在进行匹配时，会从undo log的版本链，从上到下进行挨个匹配：

- 先匹配 ![image-20241008003329258](image\image-20241008003329258.png)

这条记录，这条记录对应的trx_id为4，也就是将4带入右侧的匹配规则中。①不满足②不满足③不满足④也不满足，都不满足，则继续匹配undo log版本链的下一条。

- 再匹配第二条![image-20241008003423912](image\image-20241008003423912.png)

这条记录对应的trx_id为3，也就是将3带入右侧的匹配规则中。①不满足②不满足③不满足④也不满足，都不满足，则继续匹配undo log版本链的下一条。

- 再匹配第三条![image-20241008003548877](image\image-20241008003548877.png)

这条记录对应的trx_id为2，也就是将2带入右侧的匹配规则中。①不满足②满足 终止匹配，此次快照读，返回的数据就是版本链中记录的这条数据。

B. 再来看第二次快照读具体的读取过程:

![image-20241008003754913](image\image-20241008003754913.png)

![image-20241008003819803](image\image-20241008003819803.png)

在进行匹配时，会从undo log的版本链，从上到下进行挨个匹配：

- 先匹配![image-20241008003848478](image\image-20241008003848478.png)

这条记录，这条记录对应的trx_id为4，也就是将4带入右侧的匹配规则中。①不满足②不满足③不满足④也不满足，都不满足，则继续匹配undo log版本链的下一条。

- 再匹配第二条![image-20241008003947501](image\image-20241008003947501.png)

这条记录对应的trx_id为3，也就是将3带入右侧的匹配规则中。①不满足 ②满足。终止匹配，此次快照读，返回的数据就是版本链中记录的这条数据。

##### 6.4.4.2 RR隔离级别

>RR隔离级别下，仅在事务中第一次执行快照读时生成ReadView，后续复用该ReadView。而RR 是可重复读，在一个事务中，执行两次相同的select语句，查询到的结果是一样的。

MySQL是如何做到可重复读的?

![image-20241008004159510](image\image-20241008004159510.png)

在RR隔离级别下，只是在事务中第一次快照读时生成ReadView，后续都是复用该 ReadView，那么既然ReadView都一样，ReadView的版本链匹配规则也一样，那么最终快照读返 
回的结果也是一样的。

> 所以 MVCC的实现原理就是通过 InnoDB表的隐藏字段、UndoLog 版本链、ReadView来实现的。而MVCC + 锁，则实现了事务的隔离性。而一致性则是redolog与undolog保证。

![image-20241008004336090](image\image-20241008004336090.png)
