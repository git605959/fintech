# 데이터베이스, 테이블 만들기 (삭제 : Drop schema)
create database sampleDB;
# 데이터베이스 조회하기
SHOW databases;

#테이블 만들기
use sampleDB;
#create table 테이블명 (컬럼명1(데이터타입), 컬럼명2(데이터타입)...)
#create table customers(id(int), name(varchar(100)), sex(varchar(20)), phone(varchar(20)), address(varchar(255)));

#테이블, db 삭제는 drop
#data를 삭제하는 것은 delete

#market_db 만들기
create database market_db;
use market_db;

#hongong1 테이블 toy_id(int), toy_name(char(4)), age(int)
create table hongong1 (toy_id int, toy_name char(4), age int);
SHOW tables;
DESC hongong1;

#생성한 테이블에 데이터 입력하기 'INSERT INTO 테이블명(컬럼명1, 컬럼명2...) VALUES (값1, 값2...)'
INSERT INTO hongong1(toy_id, toy_name, age) VALUES (1,'우디',25);

SELECT * FROM hongong1;
INSERT INTO hongong1(toy_id, toy_name) VALUES (2, '버즈');

INSERT INTO hongong1(toy_name, age, toy_id) VALUES ('제시', 20, 3);
INSERT INTO hongong1 VALUES(5,'포테이토',40); #순서와 잘 맞으면 상관 없음
#INSERT INTO hongong1 VALUES(6,'강아지'); -> 에러남

create table hongong2(
	toy_id int AUTO_INCREMENT PRIMARY KEY,
    toy_name char(4),
    age int);

DESC hongong2;

#AUTO INCREMENT가 지정된 테이블에 데이터 넣기
INSERT INTO hongong2 VALUES (NULL,'보핍', 25);
SELECT * FROM hongong2;

#테이블 수정하기 alter
#컬럼 추가 ALTER TABLE 테이블명 ADD COLUMN 컬럼명, 자료형, 속성(NOT NULL, UNIQUE)
#hongong2 테이블에 country 컬럼 추가하기
ALTER TABLE hongong2 ADD COLUMN country varchar(100);

#기존 테이블에 있는 자료 UPDATE 하기 where과 함께 씀
# UPDATE 테이블명 SET 컬럼명 = 업데이트 할 값 WHERE toy_id=1;
UPDATE hongong2 SET country='미국' WHERE toy_id=1;
UPDATE hongong2 SET age=30 WHERE toy_id=1;

#테이블의 내용은 모두 지우고 테이블의 구조는 남기고 싶을 때 truncate
TRUNCATE table hongong2;
git add -> git commit
commit;

#테이블 데이터 지우고 싶을 때 delete from 테이블명 where 조건
DELETE FROM hongong1 WHERE toy_id=1 and idx2=1;

INSERT INTO hongong1 VALUES(7,'렉스',30,NULL);

#idx 컬럼추가 primary key로 지정 AUTO_INCREMENT
ALTER TABLE hongong1 ADD COLUMN idx int AUTO_INCREMENT Primary Key;
SELECT * FROM hongong1;
ALTER TABLE hongong1 DROP column idx2;

#CREATE, INSERT, UPDATE, DELETE (CRUD)

#1. 회원테이블(member) id(자동증가, primary key), member_id(char(4)), name(varchar(20)), address(varchar(200))
#2. 제품테이블(product) 제품이름(varchar(100)), 가격(int), 제조일자(char(10)), 제조회사(varchar(50)), 남은수량(int)

CREATE TABLE member(
	id int AUTO_INCREMENT PRIMARY KEY,
    member_id varchar(4),
    name varchar(20),
    address varchar(200));

CREATE TABLE product(
	name varchar(20),
    price int,
    p_date char(10),
    company varchar(20),
    l_product int);

DESC product;

INSERT INTO member VALUES(null,'tess','나훈아','경기 부천시 중동');
INSERT INTO member VALUES(null,'hero','임영웅','서울 은평구 중산동');
INSERT INTO member VALUES(null,'iyou','아이유','인천 남구 주안동');
INSERT INTO member VALUES(null,'jyp','박진영','경기 고양시 장항동');
SELECT * FROM member;

TRUNCATE table product;
INSERT INTO product 
VALUES('바나나',1500,'2024-07-01','델몬트',17),
('카스',2500,'2023-12-12','OB',3),
('삼각김밥',1000,'2025-02-26','CJ',22);
SELECT * FROM product;

# product 테이블에 prod_id 컬럼을 추가하고 Auto_increment, Primary Key를 추가
ALTER TABLE product ADD COLUMN prod_id int AUTO_INCREMENT Primary Key;

#데이터베이스/ 스키마
#데이터베이스 : 데이터를 실제로 저장하고 관리하는 물리적 저장소. 스키마를 베이스로 실제로 만든 것
#스키마 : 데이터베이스 내부의 구조적 정의(설계)를 나타내는 개념 ex. 테이블을 어떻게 만들지.  어떤 구조의 데이터를 넣을 것이며, 어떤 순서로 표현할 것인지.
#MySQL에서는 둘울 갈은 개념으로 사용.

#테이블 : 스키마를 기반으로 정의한 데이터를 저장하는 기본 단위
#행은 개별 데이터 레코드, 열은 데이터 속성(attribute)을 나타낸다.
# 	=> 엑셀의 시트라고 생각하면 됨.

#Rollback 연습
CREATE database mywork;
Use mywork;
CREATE table emp_test
(emp_no int not null,
emp_name varchar(30) not null,
hire_date date null,
salary int null,
primary key(emp_no));
DESC emp_test;

INSERT INTO emp_test (emp_no, emp_name, hire_date, salary)
VALUES
(1005, '퀴리', '2021-03-01', 4000),
(1006, '호킹','2021-03-05',5000),
(1007, '패러데이','2021-04-01',2200),
(1008, '맥스웰','2021-04-04',3300),
(1009,'플랑크','2021-04-05',4400);
SELECT * FROM emp_test;

#update 연습
# 호킹의 salary를 10,000으로 변경
# 패러데이의 hire_date를 2023-07-11로 변경
# 플랑크가 있는 데이터를 삭제
UPDATE emp_test SET salary=10000 WHERE emp_no=1006;
UPDATE emp_test SET hire_date='2023-07-11' where emp_no=1007;
DELETE FROM emp_test WHERE emp_no=1009;
#where의 기준은 primary key 열의 데이터가 기준이 되어야 함.

#오토커밋 옵션 활성화 확인
SELECT @@autocommit;	#결과값이 1이면 활성화. 0 이면 비활성화
SET autocommit = 1; #오토커밋 비활성화

CREATE TABLE emp_tran1 as select * from emp_test;
SELECT * FROM emp_tran1;
DESC emp_tran1; #primary key만 복사가 안됨. 다시 설정 필요.
DESC emp_test;
ALTER TABLE emp_tran1 add constraint primary key(emp_no); #primary key 지정
insert into emp_tran1 values(1010,'플랑크2','2024-04-05',5000);
insert into emp_tran1 values(1011,'플랑크3','2024-04-05',5000);
commit; #save point 같은 것.
insert into emp_tran1 values(1012,'플랑크4','2024-04-05',5000);
insert into emp_tran1 values(1013,'플랑크5','2024-04-05',5000);
insert into emp_tran1 values(1014,'플랑크6','2024-04-05',5000);
rollback; #commit 하기 전 데이터만 되돌아가기 가능. auto commit 상태일 경우, rollback 안될 수 있음. 



