#Entity (개체)
#데이터베이스에서 관리하고자 하는 대상 또는 객체. ex. 고객, 제품, 주문 등
#사각형(box)로 표현되며, 내부에 개체 이름이 들어감. 

#Attribute(속성) = 컬럼
#개체가 가지고 있는 특성이나 성질
#개체는 여러 속성을 가질 수 있음. ex. 고객 개체는 고객 ID, 이름, 주소, 전화번호 등의 속성을 가질 수 있다.alter
#단순 속성/ 복합 속성 / 다중 값 속성으로 분류됨.

#관계
#두 개체 간 연관성. ex. 고객과 주문 간 '주문한다'라는 관계.
#선 또는 다이아몬드 형태로 표현됨. 선 위나 관계 이름 기재.
#카디널리티(Cardinality)
#	일대일(1:1) 관계
# 	일대다(1:N) 또는 다대일(N:1) 관계
#	다대다(N:M) 관계 -> 중간에 연결 테이블(조인 테이블)을 만들어 일대다 관계로 분해.

#ERD 작성 시 고려사항
#명확한 개체 정의
#정확한 관계 설정
#정규화 : 중복 최소화.


#새로운 db import
use korea_stock_info;
show tables;
select * from stock_company_info;
select * from 2024_08_stock_price_info;

USE korea_exchange_rate;
show tables;
select count(*) from exchange_rate;
select * from exchange_rate where date >= "2020-01-01" and date <= "2021-12-31";
#2020년 1월 1일부터 12월 31일까지 데이터에서 통화별 현찰살때 환율의 최소, 최대, 평균값
select 통화, min(현찰_살때_환율) 최저가, max(현찰_살때_환율) 최고가, round(avg(현찰_살때_환율),2) 평균가 from exchange_rate where date >= "2020-01-01" and date <= "2020-12-31" group by 통화;

use korea_stock_info;
show tables;
select * from 2024_07_stock_price_info;
select * from 2024_08_stock_price_info;

#7,8,9월로 나눠져있는 데이터를 1개의 테이블로 모으기 위해서는 
#JOIN을 쓸 수 없으므로 UNION을 사용

create table stock_2024_all as
select * from 2024_07_stock_price_info
UNION ALL
select * from 2024_08_stock_price_info
UNION ALL
select * from 2024_09_stock_price_info;

# SQL 함수
# SELECT 함수(값)		MIN(), MAX(), AVG() 등

# 절대값 ABS()
SELECT ABS(-34), ABS(1), ABS(-256);

# 문자열의 길이 측정: LENGTH(문자열);
SELECT length("mysql database"); #띄어쓰기(공백)도 문자 1개로 침

# 반올림 함수 round()
SELECT round(3.14567,2); #2번째 자리까지 표기

# 올림 ceil, 내림 floor
SELECT ceil(4.5), floor(4.5);

# 연산자를 통한 계산 +,-,*,/,%(나머지),div(몫),mod(나머지)
SELECT 7/2;
SELECT 7*2;
SELECT 7 div 2; # 몫 
SELECT 7%2; #나머지
SELECT 7 mod 2;  #나머지

# power 제곱, sqrt 루트, sign 음수·양수 확인
select power(4,3);
select sqrt(3);
select sign(2), sign(-10);

#truncate(값, 자릿수) 버림
select round(2.2345,3), truncate(2.2345,3);
select round(1154.2345, -2), truncate(1154.2345, -2); #10의 자리 반올림/버림

#문자열 함수
#문자의 길이를 알아보는 함수
select char_length('my sql'), length('my sql');
select char_length('홍 길동'), length('홍 길동'); #한글의 경우 3bit. 영한문 정확한 측정을 위해서는 char_length가 정확

#문자를 연결하는 함수 concat(), concat_ws()
select concat('this', ' is ','mysql') as concat1;
select concat('this', null,'mysql') as concat1; #중간에 null값이 포함되면 전체 문자열이 null이 됨
select concat_ws(' ', 'this', 'is','mysql') as concat2; #concat_ws(구분자, 문자열1, 문자열2 ...) => 문자열1 구분자 문자열2 ...

# 대문자를 소문자로 lower(), 소문자를 대문자로 upper()
select lower("wHat Is tHis");
select upper("wHat Is tHis");

#문자열의 자릿수를 일정하게 하고 빈 공간을 지정한 문자로 채우는 함수
# lpad(값, 자릿수, 채울문자), rpad(값, 자릿수, 채울문자)
select lpad('sql', 7,"#");
select rpad('sql','5','$');

# 공백을 없애는 함수 ltrim(문자열), rtrim(문자열)
select ltrim('    SQL    }');
select rtrim('{    SQL    ');

# 문자열 공백을 앞뒤로 삭제하는 trim()
select trim('   SQL   ');
select trim('    my sql   '); #글자 사이 띄어쓰기는 삭제되지 않음.

#문자열을 잘라내는 함수 left(문자열, 길이), right(문자열, 길이)
select left('this is my sql',4), right('this is my sql',4); #' sql'로 잘림. 공백 포함 잘림
select left('이거시 my sql이다.',4), right('이거시 my sql이다.',4);

#문자열을 중간에서 잘라내는 함수 substr(문자열, 시작위치, 길이)
select substr('this is my sql', 6, 5);
select substr('this is my sql', 6);

#문자열 : 문자가 '순서'에 따라 나열된 것. '순서'가 바뀌면 다른 문자열이 되기 때문에 순서가 매우 중요. 순서에 따라 index 번호가 매겨짐.
#문자열의 공백을 앞뒤로 삭제하고 문자열 앞뒤에 포함된 특정 문자도 삭제하는 함수
# trim(leading('삭제할 문자') from 전체문자열)
select trim(leading'*' from '****my sql****');
select trim(trailing '*' from '****my sql****'); #뒤쪽부터 삭제하는 함수
select trim(both '*' from '****my sql**!**'); #양쪽에 있는 문자 삭제 함수

# 날짜형 함수
select curdate(); #현재 연월일 출력
select curtime();
select current_timestamp();
select now(); #현재 연월일 + 시간

# 요일 표시 함수
select dayname('2025-05-29'); #날짜의 요일 표시
select dayname(now());

# 오늘이 몇 번재 요일인가? (요일->숫자 표기)
select dayofweek(now()); #일(1), 월(2), 화(3), 수(4), 목(5), 금(6), 토(7)

# 1년 중 오늘이 몇일째인지 (날짜 -> 숫자 표기)
select dayofyear(now());

# 날짜를 세분화해서 보는 함수들
# 현재 달의 마지막 날이 몇일까지 있는지 출력
select last_day(now());
select last_day("2025-03-02");

# 입력한 날짜에서 연도/월/일만 추출
select year(now());
select month(now());
select day(now());
#입력한 날짜에서 월만 영문으로 출력
select monthname("2025-01-01");

# 몇 분기인가
select quarter(now());
select quarter("2025-08-01");
# 몇 주차인가
select weekofyear(now());
select weekofyear("2025-12-25");

# 날짜와 시간이 같이 있는 데이터에서 날짜와 시간 구분해주는 함수
select date(now());
select time(now());

# 날짜를 지정한 날 수 만큼 더하는 함수
# select date_add(날짜, interval 더할 날 수 day);
select date_add(now(), interval 5 day);
select adddate(now(),5); #위와 동일한 결과

# 날짜를 지정한 날 수 만큼 빼는 함수
select date_sub(now(), interval 2 day);
select subdate(now(),2);

# 날짜와 시간을 년-월, 날-시간, 분초 단위로 추출하는 함수
# extract(옵션, from 날짜 시간)
select extract(year_month from now());
select extract(day_hour from "2025-02-22"); #now 와 같이 쓰면 오류남.
select extract(minute_second from now());

# 날짜 간격 계산
# 날짜 1에서 날짜 2를 뺀 일수
select datediff(now(), "2025-12-25");
select datediff(now(), "2024-12-25");
select datediff(now(), "2025-1-1");

# 날짜 포맷 함수 - 지정한 형식에 맞춰서 출력해주는 함수
# %Y 4자리 연도, %y 2자리 연도
# %M 월의 영문표기, %m 2자리 월 표시, %b 월의 축약 영문표기
# %d 2자리 일 표기, %e 1자리 일 표기
select date_format(now(), '%d-%b-%Y');
select date_format(now(), '%d-%M-%Y');
select date_format(now(), '%e-%m-%y');

# 시간 표기
# %H 24시간, %h 12시간, %p AM, PM 표시
# %i 2자리 분 표기
# %S 2자리 초
# %T 24시간 표기법 시:분:초
# %r 12시간 표기법 시:분:초 AM/PM
# %W 요일의 영문표기, %w 숫자로 요일 표시(일 0, 월 1, 화 2, 수 3, 목 4, 금 5, 토 6)
select date_format(now(),'%H:%i:%S');
select date_format(now(),'%p %h:%i:%S');
select date_format(now(), '%T');
select date_format(now(), '%r');
select date_format("2025-02-25 17:23:54","%W %r");

