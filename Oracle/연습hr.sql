CREATE OR REPLACE PROCEDURE first_emp AS
    emp_name VARCHAR(20);
BEGIN
    SELECT first_name || ' ' || last_name INTO emp_name
    FROM employees WHERE employee_id = 100;
    DBMS_OUTPUT.PUT_LINE(emp_name);
    END;
    
SET SERVEROUTPUT ON;

EXECUTE first_emp;

CREATE OR REPLACE PROCEDURE print_emp(
    emp_id IN EMPLOYEES.EMPLOYEE_ID%TYPE
    
) AS 
    emp_name VARCHAR2(20);
BEGIN
    SELECT first_name || ' ' || last_name INTO emp_name
    FROM employees WHERE employee_id = emp_id;
    DBMS_OUTPUT.PUT_LINE(emp_name);
END;

EXECUTE print_emp(150);

--매개변수 out일때
CREATE OR REPLACE PROCEDURE emp_avg_salary(
    avg_salary OUT NUMBER
) AS
BEGIN
    SELECT AVG(salary) INTO avg_salary
    FROM employees;
END;

DECLARE
     avg_salary NUMBER;
BEGIN
    emp_avg_salary(avg_salary);
    DBMS_OUTPUT.PUT_LINE(avg_salary);
END;
--if문
CREATE OR REPLACE PROCEDURE if_salary(
    salary IN NUMBER
) AS
    avg_salary NUMBER;
BEGIN 
    SELECT AVG(salary) INTO avg_salary
    FROM employees;
    IF salary >=avg_salary THEN
        DBMS_OUTPUT.PUT_LINE('??????');
    ELSE
        DBMS_OUTPUT.PUT_LINE('??? ???');
    END IF;
END;

EXECUTE if_salary(5000);
--case문
CREATE OR REPLACE PROCEDURE case_hire_date(
    emp_email IN EMPLOYEES.EMAIL%TYPE
) AS
    hire_year NCHAR(2);
    text_msg VARCHAR(20);
BEGIN
    SELECT TO_CHAR(hire_date,'YY') INTO hire_year 
    FROM employees WHERE email = emp_email;
    
    CASE
        WHEN (hire_year = '01') THEN text_msg := '01년도에 입사';
        WHEN (hire_year = '02') THEN text_msg := '02년도에 입사';
        WHEN (hire_year = '03') THEN text_msg := '03년도에 입사';
        WHEN (hire_year = '04') THEN text_msg := '04년도에 입사';
        WHEN (hire_year = '05') THEN text_msg := '05년도에 입사';
        WHEN (hire_year = '06') THEN text_msg := '06년도에 입사';
        WHEN (hire_year = '07') THEN text_msg := '07년도에 입사';
        WHEN (hire_year = '08') THEN text_msg := '08년도에 입사';
        WHEN (hire_year = '09') THEN text_msg := '09년도에 입사';
    END CASE;
    DBMS_OUTPUT.PUT_LINE(text_msg);
END;

EXECUTE case_hire_date('SKING');


--for문

CREATE OR REPLACE PROCEDURE while_print AS
    str VARCHAR(100);
    i NUMBER;
BEGIN
    i:=1;
    while(i<=10) LOOP
    str:= '반복횟수 : ' || '(' || i || ')';
    DBMS_OUTPUT.PUT_LINE(str);
    i:= i+1;
    
    END LOOP;
END;
        
BEGIN
	while_print;
END;
-- IN과 OUT 변수가 둘다있을때 (IF문) 
CREATE OR REPLACE PROCEDURE out_emp (
	emp_id IN EMPLOYEES.EMPLOYEE_ID%TYPE,
	out_str OUT VARCHAR
) AS
	emp_name VARCHAR(20);
BEGIN
	--들어온 데이터값으로 조회가 안되는 경우의 예외처리가 필요
	SELECT FIRST_NAME || '' || LAST_NAME INTO emp_name
	FROM EMPLOYEES WHERE EMPLOYEE_ID  = emp_id;

--	IF emp_id = NULL THEN
--		out_str:= '직원: 없음';
--	ELSE
		out_str:= '직원: ' || emp_name;
	EXCEPTION
		WHEN NO_DATA_FOUND THEN 
		out_str:= '직원 : 없음';
--	END IF;
END;

DECLARE
	out_str VARCHAR2(30);
BEGIN
	out_emp(300, out_str);
	DBMS_OUTPUT.PUT_LINE(out_str);
END; 

-- 위에 프로시져의 IN OUT 변수를 한꺼번에 만들어보기
CREATE OR REPLACE PROCEDURE in_out_emp (
	emp_name IN OUT VARCHAR2
) AS
BEGIN
	--들어온 데이터값으로 조회가 안되는 경우의 예외처리가 필요
	SELECT FIRST_NAME || '' || LAST_NAME INTO emp_name
	FROM EMPLOYEES 
	WHERE FIRST_NAME = emp_name OR LAST_NAME = emp_name;
	
--	IF emp_id = NULL THEN
--		out_str:= '직원: 없음';
--	ELSE
		emp_name:= '직원: ' || emp_name;
	EXCEPTION
		WHEN NO_DATA_FOUND THEN 
		emp_name:= '직원 : 없음';
--	END IF;
END;

-- 현재 King으로 검색했을시 동명이인 즉 다중데이터가 검색되서 에러가남

DECLARE
	emp_name VARCHAR2(30) := 'King';
BEGIN
	in_out_emp(emp_name);
	DBMS_OUTPUT.PUT_LINE(emp_name);
END;
-- rowtype 응용
CREATE OR REPLACE PROCEDURE rowtype_emp(
	emp_id IN EMPLOYEES.EMPLOYEE_ID%TYPE 	
) AS
	emp_row EMPLOYEES%ROWTYPE;
BEGIN
	SELECT first_name, last_name, job_id
		INTO emp_row.fisrt_name, emp_row.last_name, emp_row.job_id
	FROM EMPLOYEES WHERE employee_id = emp_id;
	DBMS_OUTPUT.PUT_LINE(emp_row.fisrt_name ||'|'|| emp_row.last_name ||'|'||
	emp_row.job_id);
	
END;

BEGIN
	rowtype_emp(100);
END;

--레코드타입

CREATE OR REPLACE PROCEDURE record_emp (
	emp_id IN EMPLOYEES.EMPLOYEE_ID%TYPE
) AS 
	TYPE emp_type IS RECORD (first_name VARCHAR2(10),
							 last_name VARCHAR2(10),
							 job_id VARCHAR(10));
	emp_record emp_type;
BEGIN
	SELECT first_name, last_name, job_id
		INTO emp_record.first_name, emp_record.last_name, emp_record.job_id
		FROM EMPLOYEES WHERE employee_id = emp_id;
	DBMS_OUTPUT.PUT_LINE(emp_record.first_name||'|'|| emp_record.last_name||'|'||emp_record.job_id)
END;

BEGIN
	record_emp(100);
END;

--collection 타입
CREATE OR REPLACE PROCEDURE collection_ex AS 
	TYPE v_array_type IS VARRAY(5) OF NUMBER(10);
	TYPE nest_tbl_type IS TABLE OF VARCHAR2(10);
	TYPE a_array_type IS TABLE OF NUMBER(10) INDEX BY VARCHAR2(10);
	v_array v_array_type;
	nest_tbl nest_tble_type;
	a_array a_array_type;
	idx VARCHAR2(10);
BEGIN
	v_array := v_array_type(1,2,3,4,5);
	nest_tbl := nest_tbl_type('A','B','C','D','E');
	a_array('A') := 1;
	a_array('B') := 2;
	a_array('C') := 3;
	a_array('D') := 4;
	a_array('E') := 5;
	
	FOR i IN 1..5 LOOP
	DBMS_OUTPUT.PUT_LINE(v_array(i)||' | '|| nest_tbl(i));
	END LOOP;

	idx := a_array.FIRST;
	WHILE idx IS NOT NULL LOOP
		DBMS_OUTPUT.PUT_LINE(idx || ' : ' || a_array(idx));
		idx : = a_array.NEXT(idx);
	END LOOP;
	
END;

BEGIN
	collection_ex;
END;
-- collection 타입 연습
CREATE OR REPLACE PROCEDURE collection_ex2 AS 
	--type 지정  v_array_type, nest_tbl_type, a_array_type 사용
	TYPE v_array_type IS VARRAY(5) OF NUMBER(10);
	TYPE nest_tbl_type IS TABLE OF VARCHAR2(20);
	TYPE a_array_type IS TABLE OF NUMBER(10) INDEX BY VARCHAR2(20);
	--변수화
	v_array v_array_type;
	nest_tbl nest_tbl_type;
	a_array a_array_type;
	-- a_array에 사용할 index 변수 선언
	idx VARCHAR2(10);
BEGIN
	v_array := v_array_type(1,2,3,4,5);
	nest_tbl := nest_tbl_type('김밥','오징어','오므라이스','짜장면','짬뽕');
	a_array('하나') := 1;
	a_array('둘') := 2;
	a_array('셋') := 3;
	a_array('넷') := 4;
	a_array('다섯') := 5;
	
	FOR i IN 1..5 LOOP
		DBMS_OUTPUT.PUT_LINE(v_array(i)|| ' | ' || nest_tbl(i));
	END LOOP;
	
	idx :=a_array.FIRST;
	WHILE idx IS NOT NULL LOOP
		DBMS_OUTPUT.PUT_LINE(idx || ' | ' || a_array(idx));
		idx := a_array.NEXT(idx);
	END LOOP;
	
END;

BEGIN
	collection_ex2;
END;
-- cursor 커서
CREATE OR REPLACE PROCEDURE cursor_salary AS 
	sal NUMBER := 0;
	cnt NUMBER := 0;
	total NUMBER := 0;
	CURSOR emp_cursor IS SELECT salary FROM EMPLOYEES;
BEGIN
	OPEN emp_cursor;
	LOOP
		FETCH emp_cursor INTO sal;
		EXIT WHEN emp_cursor%NOTFOUND;
		total := total+sal;
		cnt := cnt + 1;
	END LOOP;
	CLOSE emp_cursor;
	DBMS_OUTPUT.PUT_LINE('평균 SALARY: ' || (total/cnt));
	
END;

BEGIN
	cursor_salary;
END;

--함수(Function)
CREATE OR REPLACE FUNCTION to_yyyymmdd(date Date)
	-- 반환값은 VARCHAR2 타입으로
	RETURN VARCHAR2
AS
	char_date VARCHAR2(20);
BEGIN
	char_date := TO_CHAR(date,'YYYYMMDD');
	RETURN char_date;
END;
-- 함수안에 함수사용
SELECT SYSDATE,to_yyyymmdd(SYSDATE) FROM dual;

CREATE OR REPLACE FUNCTION get_age(date Date)
	RETURN NUMBER
AS
	age NUMBER;
BEGIN
	age := TRUNC(MONTHS_BETWEEN(TRUNC(SYSDATE),to_yyyymmdd(date)) / 12);
	RETURN age;
END;

SELECT get_age('20010101') FROM dual;

--특정한 테이블형태로 반환하는 함수
--1.오브젝트 형태의 ename_type을 만들어줌
CREATE OR REPLACE TYPE ename_type AS OBJECT 
(
	first_name VARCHAR(20),
	last_name VARCHAR(20)
);
--2. 테이블형태의 타입을 만들어줌
CREATE OR REPLACE TYPE ename_table AS TABLE OF ename_type;

--3. 함수 만들기 return으로 만들어둔 테이블 타입 ename_table 반환
CREATE OR REPLACE FUNCTION emp_table(emp_id NUMBER)
	RETURN ename_table
	PIPELINED
AS 
	ename ename_type;
BEGIN
	FOR emp IN (SELECT first_name, last_name FROM EMPLOYEES
				WHERE EMPLOYEE_ID = emp_id)
	LOOP 
		ename := ename_type(emp.first_name, emp.last_name)
		--테이블의 로우값으로 넣음
		PIPE ROW(ename)
		
	END LOOP;
	
	RETURN;
	
END;

SELECT * FROM TABLE(emp_table(100));

--예제 IF ELSEIF ELSE 문을 사용하여 JOBS 테이블의 최저,최대 salary
--평균값을 이용하여 입력으로 받은 salary가 최저 평균 이하인지 최대 평균 이상인지, 평균 구간인지
--출력하는 프로시저정의
-- 입력받은 salary <= 최저 평균이하 , salary >= 최대 평균이상 else 평균구간	

CREATE OR REPLACE PROCEDURE if_minmax_salary(
	salary IN NUMBER
) AS 
	avg_min_salary NUMBER;
	avg_max_salary NUMBER;
BEGIN
	SELECT AVG(MIN_SALARY), AVG(MAX_SALARY)
	INTO avg_min_salary, avg_max_salary
	FROM JOBS;

	IF salary <= avg_min_salary THEN
		DBMS_OUTPUT.PUTLINE('최저 평균 이하');
	ELSE IF salary >= avg_max_salary THEN
		DBMS_OUTPUT.PUTLINE('최대 평균 이상');
	ELSE DBMS_OUTPUT.PUTLINE('평균 구간');
END;

BEGIN
	if_minmax_salary(10000);
END;

--프로시저를 이용한 구구단
CREATE OR REPLACE PROCEDURE gugudan AS 
	str VARCHAR2(100);
	i NUMBER;
	j NUMBER;
BEGIN
	i := 1;
	WHILE (i<10) LOOP
		str := '';
		j := 1;
		WHILE (j<10) LOOP
			str := i || '*' || j || '=' || i*j;
			j := j+1;
			
		END LOOP;
		DBMS_OUTPUT.PUT_LINE(str);
		i := i + 1;
	END LOOP;
	
END;

BEGIN
	gugudan;
END;

--cursor 예제
CREATE OR REPLACE PROCEDURE cursor_it_prog AS 
	fname VARCHAR(20);
	lname VARCHAR(20);
	jobid VARCHAR(20);
	CURSOR emp_cursor IS
		SELECT first_name, last_name, job_id FROM EMPLOYEES;
BEGIN
	DBMS_OUTPUT.PUT_LINE('[IT Programmer]');
	OPEN emp_cursor;
	LOOP
		FETCH emp_cursor INTO fname, lname, jobid;
		EXIT emp_cursor%NOTFOUND;
		IF jobid = 'IT_PROG' THEN
			DBMS_OUTPUT.PUT_LINE(fname || ' ' || lname);
		END IF;
	END LOOP;
	CLOSE emp_cursor;
END;

BEGIN
	cursor_it_prog;
END;

	