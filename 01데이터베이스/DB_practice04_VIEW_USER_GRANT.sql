# 사용자 추가하고 권리주기
# Navigator - Administration - Users and privileges - add account
# % : 외부 접속 가능 표시
# Account limit - MAX.Queries : 일일 호출 제한 수 (ex. API) - 무제한일 경우 서버 과부하 
# Administrative Roles - 역할 부여. DBA: 데이터베이스 총괄.(모든 권한) (쿼리 권한 부여)
# Shema Privileges - 자료(db) 별 접근 권한 부여

# 포트포워드 설정을 통해 ip주소 관리 가능.
# cmd 창에서 ipconfig all > 무선 LAN 어댑터 wi-fi 내부 주소 확인 가능.
# 외부 IP 주소 를 통해 외부 ip 확인 가능.

# view 뷰
# select로 조회한 내용을 테이블로 만드는 것처럼 저장하는 것
# 읽기 전용 (수정되지 않게)
# CREATE VIEW 뷰이름 AS SELECT문
# DROP VIEW 뷰이름 

USE korea_exchange_rate;
SELECT * FROM exchange_rate;

# 1997년 1월 1일부터 2001년 12월 31일까지 환율변동 조회
SELECT * FROM exchange_rate WHERE date between "1997-01-01" and "2001-12-31";

# 통화별로 현찰_살때_환율, 현찰_팔떄_환율의 MIN() 살때 최저 환율, MAX() 살때 최고 환율, AVG() 살때 평균 환율
# MAX() - MIN() 살때 환율 변동량
# MIN() 팔때 최저 환율, MAX() 팔때 최고 환율, AVG() 팔때 평균 환율
# MAX() - MIN() 팔때 환율 변동량

CREATE VIEW exchange_rate_1997_2001 AS
SELECT 통화, 
	MIN(현찰_살때_환율) 살때최저환율, 
	MAX(현찰_살때_환율) 살때최고환율, 
    round(AVG(현찰_살때_환율),2) 살때평균환율,
    round(MAX(현찰_살때_환율) - MIN(현찰_살때_환율),2) 살때환율변동량,
    MIN(현찰_팔때_환율) 팔때최저환율, 
    MAX(현찰_팔때_환율) 팔때최고환율, 
    round(AVG(현찰_팔때_환율),2) 팔때평균환율,
    round(MAX(현찰_팔때_환율) - MIN(현찰_팔때_환율),2) 팔때환율변동량 
    FROM exchange_rate WHERE date between "1997-01-01" and "2001-12-31"
    Group by 통화;

# view 사용 (= table과 똑같이 작동함)
SELECT * FROM exchange_rate_1997_2001;
UPDATE exchange_rate_1997_2001 SET 통화="미국" WHERE 살때최저환율=855.34; #업데이트 is not updatable 이라고 뜸. 

#과제 실습_erd 모델 생성
use database_course_erd;
show tables;

insert into department values (1,'수학');
insert into department values 
	(2,'국문학'),
    (3,'정보통신학'),
    (4,'모바일공학');
select * from department;
update department set department_name='정보통신공학' where department_id=3;

insert into student values
	(1, '가길동', 177,1),
    (2,'나길동',178,1),
    (3,'다길동',179,1),
    (4,'라길동',180,2),
    (5,'마길동',170,2),
    (6,'바길동',172,3),
    (7,'사길동',166,4),
    (8,'아길동',192,4);
select * from student;

insert into professor values
	(1,'가교수',1),
    (2,'나교수',2),
    (3,'다교수',3),
    (4,'빌게이츠',4),
    (5,'스티브잡스',3);
select * from professor;

insert into course values
	(1,'교양영어',1,'2016/9/2','2016/11/30'),
    (2,'데이터베이스 입문',3,'2016/8/20','2016/10/30'),
    (3,'회로이론',2,'2016/10/20','2016/12/30'),
    (4,'공업수학',4,'2016/11/2','2017/1/28'),
    (5,'객체지향프로그래밍',3,'2016/11/1','2017/1/30');
select * from course;

insert into student_course values
	(1,1),
    (2,1),
    (3,2),
    (4,3),
    (5,4),
    (6,5),
    (7,5);
select * from student_course;

# 문제 1
select s.student_id STUDENT_ID, s.student_name STUDENT_NAME, s.height HEIGHT, d.department_id DEPARTMENT_ID, d.department_name DEPARTMENT_NAME from student s
inner join  department d on s.department_id=d.department_id;

# 문제 2
select professor_id PROFESSOR_ID from professor where professor_name='가교수';

# 문제 3
select d.department_name, count(p.professor_id) from department d
inner join professor p on d.department_id=p.department_id
group by department_name;

# 문제 4
select s.student_id, student_name, s.height, s.department_id, d.department_name 
from student s
inner join department d on s.department_id=d.department_id
where department_name="정보통신공학";

# 문제 5
select professor_id, professor_name, p.department_id, department_name from professor p
inner join department d on p.department_id=d.department_id
where department_name='정보통신공학';

# 문제 6 성이 '아'인 학생이 속한 학과명 학생명
select student_name, department_name from student s
inner join department d on s.department_id=d.department_id
where student_name like '%아%';

# 문제 7 키가 189~190 사이에 속하는 학생 수
select count(student_id) from student
where height between 180 and 190;

# 문제 8 학과 이름별 키의 최고값, 평균값
select department_name, max(height), round(avg(height)) 'avg(height)' from student s
inner join department d on s.department_id=d.department_id
group by department_name;

# 문제 9 (**) '다길동'학생과 같은 학과에 속한 학생의 이름 출력
select student_name from student
where department_id = (select department_id from student where student_name="다길동");

# 문제 10 2016년 11월 시작하는 과목을 수강하는 학생 이름과 과목
select student_name, course_name from student s
inner join student_course sc on s.student_id=sc.student_id
inner join course c on sc.course_id=c.course_id
where c.start_date like "2016/11%";

# 문제 11 '데이터베이스 입문' 과목을 수강신청한 학생 이름
select student_name from student s
inner join student_course sc on s.student_id=sc.student_id
inner join course c on sc.course_id=c.course_id
where course_name = "데이터베이스 입문";

# 문제 12 (**) '빌게이츠' 교수의 과목을 수강신청한 학생 수
select count(sc.student_id) from professor p
inner join course c on p.professor_id=c.professor_id
inner join student_course sc on c.course_id=sc.course_id
where p.professor_name = "빌게이츠";