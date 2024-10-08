# DDL 英文全称 Data Definition Language，数据定义语言，用来定义数据库对象(数据库，表，字段) 。
# 查询所有数据库:
SHOW DATABASES;

# 查询当前数据库:
SELECT DATABASE(); 

# 创建数据库
CREATE DATABASE IF NOT EXISTS cs DEFAULT CHARSET utf8mb4 COLLATE utf8mb4_unicode_ci;

# 删除数据库
DROP DATABASE IF EXISTS cs;

# 使用数据库
USE cs;

# 查询当前数据库所有表
SHOW TABLES;

# 创建员工表
CREATE TABLE emp (
  id INT COMMENT '编号',
  workno VARCHAR(10) COMMENT '员工工号',
  name VARCHAR(10) COMMENT '员工姓名',
  gender CHAR(1) COMMENT '性别',
  age TINYINT(3) COMMENT '年龄',
  idcard CHAR(18) COMMENT '身份证号',
  entrydate DATE COMMENT '入职时间'
  ) COMMENT '员工表';
	
# 查询表结构
DESC emp;

# 查询指定表的建表语句：
SHOW CREATE TABLE emp;

# 为emp表添加新字段“呢称”nickname,类型为varchar(20)
ALTER TABLE emp ADD nickname VARCHAR(20) COMMENT '呢称';

# 修改数据类型
ALTER TABLE emp MODIFY nickname VARCHAR(30);

# 将emp表的nickname字段修改为username，类型为varchar(30)
ALTER TABLE emp CHANGE nickname username varchar(30) comment '呢称';

# 将emp表字段username删除
ALTER TABLE emp DROP username;

# 将emp表名改为emps
ALTER TABLE emp RENAME TO emps;

# 如果tb_user表存在，则删除tb_user表
DROP TABLE IF EXISTS tb_user;

# 删除指定表，并重新创建表（似清空表数据）
TRUNCATE TABLE emp;

--
--
--
# DML 英文全称是Data Manipulation Language(数据操作语言)，用来对数据库中表的数据记录进行增、删、改操作。
# 给emps表所有字段添加数据
INSERT INTO emps(id,workno,name,gender,age,idcard,entrydate) VALUES(1,'1','coisini','男',20,'987654321012345678','2000-01-01');

# 查询
SELECT * FROM emps;

# 插入数据到emps表
INSERT INTO emps VALUE(2,'2','萧萧','男',18,'987654321012345678','2001-01-01');

# 批量插入数据到emps表
INSERT INTO emps VALUES(3,'3','3号员工','女',20,'123456789123456789','2000-12-12'),(4,'4','4号员工','女',19,'123456789123456780','2000-09-09'),(5,'5','5号员工','女',21,'123456789123456700','2000-05-12');

# 将id为1的name字段值修改为 coisini.cn
UPDATE emps SET name = 'coisini.cn' WHERE id = 1;

# 将id为1的name字段值修改为 小小，gender修改为 女
UPDATE emps SET name = '小小',gender = '女' WHERE id = 1;

# 修改`所有员工`入职日期为：2002-02-02
UPDATE emps SET entrydate = '2002-02-02';

# 删除gender为 男 的员工
DELETE FROM emps WHERE gender = '男';

# 删除所有员工
DELETE FROM emps;

--
--
--
# DQL 英文全称是Data Query Language(数据查询语言)，数据查询语言，用来查询数据库中表的记录。
# 查询关键字: SELECT
# 数据准备
DROP TABLE IF EXISTS emps;
CREATE TABLE emps(
    id int COMMENT '编号',
    workno varchar(10) COMMENT '工号',
    name varchar(10) COMMENT '姓名',
    gender char(1) COMMENT '性别',
    age tinyint UNSIGNED COMMENT '年龄',
    idcard char(18) COMMENT '身份证号',
    workaddress varchar(50) COMMENT '工作地址',
    entrydate date COMMENT '入职时间'
) COMMENT '员工表';
INSERT INTO emps (id, workno, name, gender, age, idcard, workaddress, entrydate) VALUES (1, '00001', '0011', '女', 20, '123456789012345678', '北京', '2000-01-01');
INSERT INTO emps (id, workno, name, gender, age, idcard, workaddress, entrydate) VALUES (2, '00002', '张无忌', '男', 18, '123456789012345670', '北京', '2005-09-01');
INSERT INTO emps (id, workno, name, gender, age, idcard, workaddress, entrydate) VALUES (3, '00003', '韦一笑', '男', 38, '123456789712345670', '上海', '2005-08-01');
INSERT INTO emps (id, workno, name, gender, age, idcard, workaddress, entrydate) VALUES (4, '00004', '赵敏', '女', 18, '123456757123845670', '北京', '2009-12-01');
INSERT INTO emps (id, workno, name, gender, age, idcard, workaddress, entrydate) VALUES (5, '00005', '小昭', '女', 16, '123456769012345678', '上海', '2007-07-01');
INSERT INTO emps (id, workno, name, gender, age, idcard, workaddress, entrydate) VALUES (6, '00006', '杨逍', '男', 28, '12345678931234567X', '北京', '2006-01-01');
INSERT INTO emps (id, workno, name, gender, age, idcard, workaddress, entrydate) VALUES (7, '00007', '范瑶', '男', 40, '123456789212345670', '北京', '2005-05-01');
INSERT INTO emps (id, workno, name, gender, age, idcard, workaddress, entrydate) VALUES (8, '00008', '黛绮丝', '女', 38, '123456157123645670', '天津', '2015-05-01');
INSERT INTO emps (id, workno, name, gender, age, idcard, workaddress, entrydate) VALUES (9, '00009', '范凉凉', '女', 45, '123156789012345678', '北京', '2010-04-01');
INSERT INTO emps (id, workno, name, gender, age, idcard, workaddress, entrydate) VALUES (10, '00010', '陈友谅', '男', 53, '123456789012345670', '上海', '2011-01-01');
INSERT INTO emps (id, workno, name, gender, age, idcard, workaddress, entrydate) VALUES (11, '00011', '张士诚', '男', 55, '123567897123465670', '江苏', '2015-05-01');
INSERT INTO emps (id, workno, name, gender, age, idcard, workaddress, entrydate) VALUES (12, '00012', '常遇春', '男', 32, '123446757152345670', '北京', '2004-02-01');
INSERT INTO emps (id, workno, name, gender, age, idcard, workaddress, entrydate) VALUES (13, '00013', '张三丰', '男', 88, '123656789012345678', '江苏', '2020-11-01');
INSERT INTO emps (id, workno, name, gender, age, idcard, workaddress, entrydate) VALUES (14, '00014', '灭绝', '女', 65, '123456719012345670', '西安', '2019-05-01');
INSERT INTO emps (id, workno, name, gender, age, idcard, workaddress, entrydate) VALUES (15, '00015', '胡青牛', '男', 70, '12345674971234567X', '西安', '2018-04-01');
INSERT INTO emps (id, workno, name, gender, age, idcard, workaddress, entrydate) VALUES (16, '00016', '周芷若', '女', 18, null, '北京', '2012-06-01');

# 查询指定字段并返回
SELECT id,workno,name,gender,age,idcard,workaddress,entrydate FROM emps;

# 查询所有员工的工作地址，起别名（as可以省略）
SELECT workaddress as '工作地址' from emps;

# 查询公司员工上班地址有哪些（去重）
SELECT DISTINCT workaddress '工作地址' FROM emps;

# 查询年龄等于88的员工
SELECT * FROM emps WHERE age = 88;

# 查询年龄小于20的员工信息
SELECT * FROM emps WHERE age < 20;

# 查询年龄小于等于20的员工信息
SELECT * FROM emps WHERE age <= 20;

# 查询没有身份证号的员工
SELECT * FROM emps WHERE idcard IS null;

# 查询有身份证号的员工
SELECT * FROM emps WHERE idcard IS NOT null;

# 查询年龄不等于88的员工
SELECT * FROM emps WHERE age != 88;
SELECT * FROM emps WHERE age <> 88;

# 查询年龄在15岁（包含）到20岁（包含）之间的员工信息
SELECT * FROM emps WHERE age >= 15 && age <= 20;
SELECT * FROM emps WHERE age >= 15 AND age <= 20;
SELECT * FROM emps WHERE age BETWEEN 15 AND 20;

# 查询性别为 女 且 年龄小于 25岁的员工信息
SELECT * FROM emps WHERE gender = '女' AND age < 25;
SELECT * FROM emps WHERE gender = '女' && age < 25;

# 查询年龄等于 18 或 20 或 40 的员工信息
SELECT * FROM emps WHERE age = 18 OR age = 20 OR age = 40;
SELECT * FROM emps WHERE age = 18 || age = 20 || age = 40;
SELECT * FROM emps WHERE age IN(18,20,40);

# 查询姓名为两个字的员工信息
SELECT * FROM emps WHERE name LIKE '__';

# 查询身份证号最后一位是X的员工信息
SELECT * FROM emps WHERE idcard LIKE '%X';
SELECT * FROM emps WHERE idcard LIKE '_________________X';

# 统计该企业员工数量
SELECT COUNT(*) FROM emps;

# 统计idcard字段不为null数
SELECT COUNT(idcard) FROM emps;

# 统计总记录数
SELECT COUNT(1) FROM emps;

# 统计该企业员工平均年龄
SELECT AVG(age) FROM emps;

# 统计该企业员工最大年龄
SELECT MAX(age) FROM emps;

# 统计该企业员工最小年龄
SELECT MIN(age) FROM emps;

# 统计该企业西安地区员工年龄之和
SELECT SUM(age) FROM emps WHERE workaddress = '西安';

# 根据性别分组，统计男性员工和女性员工的数量
SELECT gender, COUNT(*) FROM emps GROUP BY gender;

# 根据性别分组，统计男性员工和女性员工的平均年龄
SELECT gender, AVG(age) FROM emps GROUP BY gender;

# 查询年龄小于45的员工, 并根据工作地址分组, 获取员工数量大于等于3的工作地址
SELECT workaddress, COUNT(*) address_count FROM emps WHERE age < 45 GROUP BY workaddress HAVING address_count >=3;

# 统计各个工作地址上班的男性及女性员工的数量
SELECT workaddress,gender,COUNT(*) '数量' FROM emps GROUP BY workaddress,gender;

# 根据年龄对公司的员工进行升序排序（ASC默认可不写）
SELECT * FROM emps ORDER BY age ASC;

# 根据入职时间, 对员工进行降序排序
SELECT * FROM emps ORDER BY entrydate DESC;

# 根据年龄对公司的员工进行升序排序, 年龄相同, 再按照入职时间进行降序排序
SELECT * FROM emps ORDER BY age ASC, entrydate DESC;

# 查询第1页员工数据, 每页展示10条记录
SELECT * FROM emps LIMIT 0, 10;
SELECT * FROM emps LIMIT 10;

# 查询第2页员工数据, 每页展示10条记录 `(页码-1) * 页展示记录数`
SELECT * FROM emps LIMIT 10,10;

# 查询年龄为20,21,22,23岁的 女员工信息。
SELECT * FROM emps WHERE gender = '女' AND age IN(20,21,22,23);
SELECT * FROM emps WHERE gender = '女' AND age = 20 OR age = 21 OR age = 22 OR age = 23;

# 查询性别为男，并且年龄在20-40 岁(含)以内的姓名为三个字的员工。
SELECT * FROM emps WHERE gender = '男' AND( age BETWEEN 20 AND 40 ) AND name LIKE '___';

# 统计员工表中, 年龄小于60岁的, 男性员工和女性员工的人数。
SELECT gender, COUNT(*) FROM emps WHERE age < 60 GROUP BY gender;

# 查询所有年龄小于等于35岁员工的姓名和年龄，并对查询结果按年龄升序排序，如果年龄相同按入职时间降序排序。
SELECT name, age FROM emps WHERE age <= 35 ORDER BY age ASC, entrydate DESC;

# 查询性别为男，且年龄在20-40 岁(含)以内的前5个员工信息，对查询的结果按年龄升序排序，年龄相同按入职时间升序排序。
SELECT * FROM emps WHERE gender = '男' AND (age BETWEEN 20 AND 40)ORDER BY age ASC, entrydate DESC LIMIT 0,5;

# 查询年龄大于15的员工姓名、年龄，并根据年龄进行升序排序。
SELECT name,age FROM emps WHERE age >15 ORDER BY age ASC;

# 给emp表起一个别名e，然后在select及where中使用该别名
SELECT e.name,e.age FROM emps e WHERE e.age >15 ORDER BY e.age ASC;

# 执行顺序 FROM ... WHERE ... GROUP BY ... HAVING ... SELECT ... ORDER BY  ... LIMIT ...

--
--
--
# DCL 英文全称是 Data Control Language(数据控制语言)，用来管理数据库用户、控制数据库的访问权限。
# 查询用户
SELECT * FROM mysql.user;
# 其中 Host代表当前用户访问的主机,如果为localhost,仅代表只能够在当前本机访问，是不可以远程访问的。 User代表的是访问该数据库的用户名。在MySQL中需要通过Host和User来唯一标识一 个用户。

# 创建用户 coisini , 只能够在当前主机 localhost 访问, 密码123456;
CREATE USER 'coisini'@'localhost' IDENTIFIED BY '123456';

# 创建用户 xiao , 可以在任意主机访问该数据库, 密码123456；
CREATE USER 'xiao'@'%' IDENTIFIED BY '123456';

# 修改用户 xiao 的访问密码为12345;
-- MySQL8.0语法
ALTER USER 'xiao'@'%' IDENTIFIED WITH mysql_native_password BY '1234';
-- MySQL9.0语法
ALTER USER 'xiao'@'%' IDENTIFIED BY '1234';

# 删除coisini@localhost 用户
DROP USER 'coisini'@'localhost';

# 查询 'xiao'@'%' 用户权限
SHOW GRANTS FOR 'xiao'@'%';

# 授予 'xiao'@'%' 用户 emps数据库 所有表 的所有操作权限
GRANT ALL ON emps.* TO 'xiao'@'%';

# 撤销 'xiao'@'%' 用户的 emps 数据库的所有权限
REVOKE ALL ON emps.* FROM 'xiao'@'%';

--
--
--
# 函数
# CONCAT: 拼接字符串
SELECT CONCAT('HELLO','MySQL');

# LOWER: 全部转小写
SELECT LOWER('Hello');

# UPPER: 全部转大写
SELECT UPPER('Hello');

# LPAD: 左填充(---01)
SELECT LPAD('01',5,'-');

# RPAD: 右填充
SELECT RPAD('01',5,'-');

# TRIM: 去除空格
SELECT TRIM(' 1 Hello MySQL 1');

# SUBSTRING: 截取子字符串
SELECT SUBSTRING('Hello MySQL',1,5);
--
# 工号统一为5位数，目前不足5位数的全部在前面补0。比如：1号员工工号应为00001
UPDATE emps SET workno = LPAD(workno,5,'0');
SELECT workno FROM emps;


# CEIL: 向上取整(1.1 -> 2)
SELECT CEIL(1.1);

# FLOOR: 向下取整(1.9 -> 1)
SELECT FLOOR(1.9);

# MOD: 取模 (7,4 -> 3)
SELECT MOD(7,4);

# RAND: 获取随机数
SELECT RAND();

# ROUND: 四舍五入
SELECT ROUND(2.344,2);

# 通过数据库的函数，生成一个六位数的随机验证码。
-- 获取随机数可以通过rand()函数，但是获取出来的随机数是在0-1之间的，所以可以在其基础上乘以1000000，然后舍弃小数部分，如果长度不足6位，补0
SELECT LPAD(ROUND(RAND()*1000000, 0), 6,'0');

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

# 查询所有员工的入职天数，并根据入职天数倒序排序。
-- 入职天数，通过当前日期-入职日期，用datediff函数来完成。
SELECT name, DATEDIFF(CURDATE(), entrydate) entryDay FROM emps ORDER BY entryDay DESC;

# IF 如果value为true，则返回t，否则返回f
SELECT IF(FALSE, 'OK','ERROR');

# IFNULL 如果value1不为空，返回value1，否则返回value2
SELECT IFNULL('OK','DEFAULT');
SELECT IFNULL('','DEFAULT');
SELECT IFNULL(NULL,'DEFAULT');

# CASE WHEN THEN ELSE END
-- 查询emps表的员工姓名和工作地址（北京/上海 -》一线城市，其它 -》二线城市）
SELECT name, CASE workaddress WHEN '北京' THEN '一线城市' WHEN '上海' THEN '一线城市' ELSE '二线城市' END FROM emps;

--
# 数据准备
CREATE TABLE score(
       id int COMMENT 'ID',
       name varchar(20) COMMENT '姓名',
       math int COMMENT '数学',
       english int COMMENT '英语',
       chinese int COMMENT '语文'
   ) COMMENT '学员成绩表';
INSERT INTO score(id, name, math, english, chinese) VALUES (1, 'Tom', 67, 88, 95), (2, 'Rose' , 23, 66, 90),(3, 'Jack', 56, 98, 76);

# 分数 >=85 优秀，>=60 及格，其它不及格
SELECT name, 
(CASE WHEN math >= 85 THEN '优秀' WHEN math >= 60 THEN '及格' ELSE '不及格' END) '数学',
(CASE WHEN english >= 85 THEN '优秀' WHEN english >= 60 THEN '及格' ELSE '不及格' END) '英语',
(CASE WHEN chinese >= 85 THEN '优秀' WHEN chinese >= 60 THEN '及格' ELSE '不及格' END) '语文'
FROM score;

-- 数据库中，存储的是入职日期，如2000-01-01，快速计算出入职天数  DATEDIFF
SELECT `name`, DATEDIFF(CURDATE(), entrydate) FROM emps;

-- 数据库中，存储的是学生的分数值，如98、75，快速判定分数的等级 CASE ... WHEN ...
SELECT name, 
(CASE WHEN math >= 98 THEN '优秀' WHEN math >= 75 THEN '及格' ELSE '良好' END) '数学',
(CASE WHEN english >= 98 THEN '优秀' WHEN english >= 75 THEN '及格' ELSE '良好' END) '英语',
(CASE WHEN chinese >= 98 THEN '优秀' WHEN chinese >= 75 THEN '及格' ELSE '良好' END) '语文'
FROM score;

--
--
--
# 约束
CREATE TABLE tb_user(
	id int AUTO_INCREMENT PRIMARY KEY COMMENT 'id主键',
    name VARCHAR(10) NOT NULL UNIQUE COMMENT '姓名',
    age int CHECK(age > 0 && age <= 120) COMMENT '年龄',
    status CHAR(1) DEFAULT '1' COMMENT '状态',
    gender CHAR(1) COMMENT '性别'
) COMMENT '用户表';

# 添加数据（测试约束有效性）
INSERT INTO tb_user(name,age,status,gender) VALUES ('Tom1',19,'1','男'), ('Tom2',25,'0','男');
INSERT INTO tb_user(name,age,status,gender) VALUES ('Tom3',19,'1','男');
INSERT INTO tb_user(name,age,status,gender) VALUES (null,19,'1','男');
INSERT INTO tb_user(name,age,status,gender) VALUES ('Tom3',19,'1','男');
INSERT INTO tb_user(name,age,status,gender) VALUES ('Tom4',80,'1','男');
INSERT INTO tb_user(name,age,status,gender) VALUES ('Tom5',-1,'1','男');
INSERT INTO tb_user(name,age,status,gender) VALUES ('Tom5',121,'1','男');
INSERT INTO tb_user(name,age,gender) VALUES ('Tom5',120,'男');

--
# 外键约束
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

SELECT * FROM emp;
SELECT * FROM dept;

# 尝试删除id为1的部门信息
DELETE FROM dept WHERE id = 1;

# 创建外键
ALTER TABLE emp ADD CONSTRAINT fk_emp_dept_id FOREIGN KEY (dept_id)REFERENCES dept(id);

# 尝试删除id为1的部门信息
DELETE FROM dept WHERE id = 1;

#删除emp表的外键fk_emp_dept_id
ALTER TABLE emp DROP FOREIGN KEY fk_emp_dept_id;

# CASCADE 当在父表中删除/更新对应记录时，首先检查该记录是否有对应外键，如果有，则也删除/更新外键在子表中的记录。
ALTER TABLE emp ADD CONSTRAINT fk_emp_dept_id FOREIGN KEY (dept_id) REFERENCES dept(id) ON UPDATE CASCADE ON DELETE CASCADE;

# 父表id为1的值修改为6
UPDATE dept  SET id = '6' WHERE id = '1';

# 此时查询emp，dept_id会联动修改
SELECT * FROM emp;

# SET	NULL 当在父表中删除对应记录时，首先检查该记录是否有对应外键，如果有则设置子表中该外键值为null（这就要求该外键允许取null）。
ALTER TABLE emp ADD CONSTRAINT fk_emp_dept_id FOREIGN KEY (dept_id) REFERENCES dept(id) ON UPDATE SET null ON DELETE SET null ;

# 此时删除id为6的部门数据
DELETE FROM dept WHERE id = '6';

# 此时查询emp，dept_id会联动修改为NULL
SELECT * FROM emp;

# 多对多
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
    id int AUTO_INCREMENT PRIMARY KEY COMMENT '主键',
    studentid int NOT null COMMENT '学生ID',
    courseid int NOT null COMMENT '课程ID',
    CONSTRAINT fk_courseid FOREIGN KEY (courseid) REFERENCES course (id),
    CONSTRAINT fk_studentid FOREIGN KEY (studentid) REFERENCES student (id)
   )COMMENT '学生课程中间表';

INSERT INTO student_course VALUES (null,1,1),(null,1,2),(null,1,3),(null,2,2), (null,2,3),(null,3,4);

# 一对一
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

--
--
--
# 多表查询
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

# 多表查询
SELECT *  FROM emp,dept WHERE emp.dept_id = dept.id;

# 查询每一个员工的姓名，及关联的部门的名称（隐式内连接实现）
SELECT emp.name, dept.name FROM emp, dept WHERE emp.dept_id = dept.id;

-- 简写
select e.name,d.name from emp e , dept d where e.dept_id = d.id;

# 查询每一个员工的姓名，及关联的部门的名称（显示内连接实现）INNER JON
SELECT e.name, d.name FROM emp e INNER JOIN dept d ON e.dept_id = d.id;

-- 简写
SELECT e.name, d.name FROM emp e JOIN dept d ON e.dept_id = d.id;

# 查询emp表的所有数据, 和对应的部门信息。（使用左外连接查询）
SELECT e.*, d.name FROM emp e LEFT OUTER JOIN dept d ON e.dept_id = d.id;

-- 简写
SELECT e.*, d.name FROM emp e LEFT JOIN dept d ON e.dept_id = d.id;

# 查询dept表所有数据，和对应的员工信息（使用外连接查询）
-- 右外连接
SELECT d.*, e.* FROM emp e RIGHT OUTER JOIN dept d ON e.dept_id = d.id;

-- 左外连接
SELECT d.*, e.* FROM dept d LEFT OUTER JOIN emp e ON e.dept_id = d.id;

# 自连接 
# SELECT 字段列表 FROM 表A 别名A JOIN 表A 别名B ON 条件...;
# 查询员工 及其领导的名字
# emp
SELECT a.name, b.name FROM emp a , emp b WHERE a.managerid = b.id;
SELECT a.name, b.name FROM emp a JOIN emp b ON a.managerid = b.id;

#查询所有员工 emp 及其领导的名字 emp , 如果员工没有领导, 也需查询出来
#表结构: emp a , emp b
SELECT a.name '员工', b.name '领导' FROM emp a LEFT JOIN emp b ON a.managerid = b.id;

# 联合查询
# 将薪资低于5000的员工，和 年龄大于50岁的员工查询出来。
# UNION ALL 仅仅简单合并，未去重
SELECT * FROM emp WHERE salary < 5000 UNION ALL SELECT * FROM emp  WHERE age > 50;

# UNION 可去重
SELECT * FROM emp WHERE salary < 5000 UNION SELECT * FROM emp  WHERE age > 50;

# 如果多条查询语句查询出来的结果，字段数量不一致，在进行union/union all联合查询时，将会报错。
SELECT * FROM emp WHERE salary < 5000 
UNION 
SELECT name FROM emp  WHERE age > 50;
-- 1222 - The used SELECT statements have a different number of columns

# 标量子查询
# 查询“销售部”所有员工信息
SELECT * FROM emp WHERE dept_id = (SELECT id FROM dept WHERE name = '销售部');

# 查询在“方东白”入职之后的员工信息
SELECT * FROM emp WHERE entrydate > (SELECT entrydate FROM emp WHERE name = '方东白');

# 查询“销售部” 和 “市场部” 的所有员工信息
SELECT id FROM dept WHERE name = '销售部' OR name = '市场部';
SELECT * FROM emp WHERE dept_id IN (SELECT id FROM dept WHERE name = '销售部' OR name = '市场部');

# 查询比财务部所有人工资都高的信息
-- 查询 财务部 用户id
SELECT id FROM dept WHERE name = '财务部';

-- 查询 财务部用户工资
SELECT salary FROM emp WHERE dept_id = (SELECT id FROM dept WHERE name = '财务部');

-- 查询比财务部所有人工资都高的信息
SELECT * FROM emp WHERE salary > ALL (SELECT salary FROM emp WHERE dept_id = (SELECT id FROM dept WHERE name = '财务部'));

# 查询比研发部其中任意一人工资高的员工信息
-- 查询研发部所有人工资
SELECT salary FROM emp WHERE dept_id = (SELECT id FROM dept WHERE name = '研发部');

-- 比研发部其中任意一人工资高的员工信息
SELECT * FROM emp WHERE salary > ANY(SELECT salary FROM emp WHERE dept_id = (SELECT id FROM dept WHERE name = '研发部'));

# 查询与“张无忌”的薪资及直属领导相同的员工信息
-- 查询“张无忌”的薪资及直属领导
SELECT salary,managerid FROM emp WHERE name = '张无忌';

-- 查询与"张无忌" 的薪资及直属领导相同的员工信息
SELECT * FROM emp WHERE (salary,managerid) = (SELECT salary,managerid FROM emp WHERE name = '张无忌');

# 查询与"鹿杖客", "宋远桥"的职位和薪资相同的员工信息。
-- 查询"鹿杖客", "宋远桥" 的职位和薪资
SELECT job,salary FROM emp WHERE name = '鹿杖客' OR name = '宋远桥';

-- 查询与"鹿杖客", "宋远桥" 的职位和薪资相同的员工信息
SELECT * FROM emp WHERE (job,salary) IN (SELECT job,salary FROM emp WHERE name = '鹿杖客' OR name = '宋远桥');

# 查询入职日期“2006-01-01”之后的员工信息，及其部分信息
-- 入职日期是"2006-01-01" 之后的员工信息
SELECT * FROM emp WHERE entrydate > '2006-01-01';

-- 查询这部分员工, 对应的部门信息;
SELECT e.*, d.* FROM (SELECT * FROM emp WHERE entrydate > '2006-01-01') e LEFT JOIN dept d ON e.dept_id = d.id;

--
--
# 多表查询
# 数据准备

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

# 查询员工的姓名、年龄、职位、部门信息（隐式内连接） 
# 表: emp, dept 连接条件: emp.dept_id = dept.id
SELECT e.name '姓名',e.age '年龄', e.job '职位', d.name '部门信息'
FROM emp e, dept d 
WHERE e.dept_id = d.id;

# 查询年龄小于30岁的员工的姓名、年龄、职位、部门信息（显式内连接） 
# 表: emp , dept 连接条件: emp.dept_id = dept.id
SELECT e.name '姓名',e.age '年龄', e.job '职位', d.name '部门信息'
FROM emp e INNER JOIN dept d ON e.dept_id = d.id WHERE age < 30;

# 查询拥有员工的部门ID、部门名称 
# 表: emp , dept
# 连接条件: emp.dept_id = dept.id
SELECT DISTINCT d.id, d.name
FROM emp e, dept d
WHERE e.dept_id = d.id;

# 查询所有年龄大于40岁的员工, 及其归属的部门名称; 如果员工没有分配部门, 也需要展示出来(外连接)
# 表: emp , dept
# 连接条件: emp.dept_id = dept.id
SELECT e.*,d.name
FROM emp e
LEFT JOIN dept d ON e.dept_id = d.id WHERE e.age > 40;

# 查询所有员工的工资等级 
# 表: emp , salgrade
# 连接条件 : emp.salary >= salgrade.losal and emp.salary <= salgrade.hisal
SELECT e.*, s.grade, s.losal, s.hisal
FROM emp e, salgrade s
WHERE e.salary >= s.losal and e.salary <= s.hisal;
--
SELECT e.*, s.grade, s.losal, s.hisal
FROM emp e, salgrade s
WHERE e.salary BETWEEN s.losal AND s.hisal;

# 查询"研发部" 所有员工的信息及工资等级表: emp, salgrade, dept
# 连接条件: emp.salary between salgrade.losal and salgrade.hisal, emp.dept_id = dept.id
# 查询条件: dept.name = '研发部'
SELECT e.*, s.grade
FROM emp e, salgrade s, dept d
WHERE e.dept_id = d.id AND (e.salary BETWEEN s.losal AND s.hisal) AND
d.name = '研发部';

# 查询"研发部" 员工的平均工资 
# 表: emp , dept
# 连接条件 : emp.dept_id = dept.id
SELECT AVG(e.salary)
FROM emp e, dept d
WHERE e.dept_id = d.id AND d.name = '研发部';

# 查询工资比"灭绝" 高的员工信息。 
-- ① 查询"灭绝" 的薪资
SELECT salary
FROM emp
WHERE name = '灭绝';
-- ② 查询比她工资高的员工数据
SELECT *
FROM emp
WHERE salary > (SELECT salary FROM emp WHERE name = '灭绝');


# 查询比平均薪资高的员工信息 
-- ① 查询员工的平均薪资
SELECT AVG(salary) FROM emp;
-- ② 查询比平均薪资高的员工信息
SELECT e.*
FROM emp e
WHERE salary > (SELECT AVG(salary) FROM emp);

# 查询低于本部门平均工资的员工信息 
-- ① 查询指定部门平均薪资
SELECT AVG(salary) FROM emp e WHERE e.dept_id = 1;
SELECT AVG(salary) FROM emp e WHERE e.dept_id = 2;
-- ② 查询低于本部门平均工资的员工信息
SELECT *
FROM emp e2
WHERE e2.salary < (SELECT AVG(salary) FROM emp e1 WHERE e1.dept_id = e2.dept_id);

# 查询所有的部门信息, 并统计部门的员工人数
SELECT d.id, d.name, (SELECT COUNT(*) FROM emp e WHERE e.dept_id = d.id) '人数'
FROM dept d;

# 查询所有学生的选课情况, 展示出学生名称, 学号, 课程名称 
# 表: student, course, student_course
# 连接条件: student.id = student_course.studentid, course.id = student_course.courseid
SELECT s.name '学生名称', s.NO '学号', c.name '课程名称'
FROM student s, course c, student_course sc
WHERE s.id = sc.studentid
AND	c.id = sc.courseid;

--
--
--
# 事务操作
-- 数据准备
DROP TABLE IF EXISTS account;

CREATE TABLE account(
		id int PRIMARY KEY AUTO_INCREMENT COMMENT 'ID主键',
    name VARCHAR(10) COMMENT '姓名',
    money DOUBLE(10,2) COMMENT '余额'
) COMMENT '账户表';

INSERT INTO account(name, money) VALUES ('张三',2000),('李四', 2000);

# 正常操作
-- 1. 查询张三余额
SELECT * FROM account WHERE name = '张三';
-- 2. 张三的余额减少1000
UPDATE account SET money = money - 1000 WHERE name = '张三';
-- 3. 李四的余额增加1000
UPDATE account SET money = money + 1000 WHERE name = '李四';

# 异常操作
-- 1. 查询张三余额
SELECT * FROM account WHERE name = '张三';
-- 2. 张三的余额减少1000
UPDATE account SET money = money - 1000 where name = '张三';
 出错了....
 -- 3. 李四的余额增加1000
UPDATE account SET money = money + 1000 where name = '李四';


# 控制事务一
-- 查看/设置事务提交方式
SELECT @@autocommit;
SET @@autocommit = 0;
-- 提交事务
COMMIT;
-- 回滚事务
ROLLBACK;

# 控制事务二
-- 开启事务
START TRANSACTION 或 BEGIN ;
-- 提交事务
COMMIT;
-- 回滚事务
ROLLBACK;

# 转账案例
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

--
# 查看事务隔离级别
SELECT @@TRANSACTION_ISOLATION;
-- READ UNCOMMITTED
-- READ COMMITTED
-- REPEATABLE READ
-- SERIALIZABLE

# 设置事务隔离
SET  [ SESSION | GLOBAL ]  TRANSACTION  ISOLATION LEVEL  { READ UNCOMMITTED | READ COMMITTED | REPEATABLE READ | SERIALIZABLE }

-- 事务隔离级别越高，数据越安全，但是性能越低。