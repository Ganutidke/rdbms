1.create or replace function ab(text) returns text as'
declare
s_name text;
s_lname text;
found_stud stud%rowtype;
begin
select into found_stud * from stud where sname=s_name;
raise notice ''s_name,lname % %'',found_stud.sname,found_stud.slname;
return null;
end;'
language 'plpgsql';

Output:

AS=# select ab('abc');
NOTICE:  s_name <NULL>
 ab 
----
 
(1 row)

AS=# select * from stud;
 sname | slname 
-------+--------
 abc   | pawar
 def   | jadhav
 pqr   | kadam
(3 rows)

AS=# select ab('xxx');
NOTICE:  s_name <NULL>
 ab 
----
 
(1 row)


2. create or replace  function add(a int,b int) returns int as'
declare
c int;
begin
c:=a+b;
return c;
end;'
language 'plpgsql';

output:

CREATE FUNCTION
AS=# select add(2,4);
 add 
-----
   6
(1 row)

AS=# select add(5,6);
 add 
-----
  11
(1 row)

3. create or replace function n(int) returns text as'
declare
a alias for $1;
e_name text;
begin
select into e_name ename from emp1 where eid=a;
return e_name;
end;'
language 'plpgsql';


output:


AS=# select n(5);
  n   
------
 ddfg
(1 row)

AS=# select * from emp1;
 eid | ename | esal  
-----+-------+-------
   1 | aaa   | 20000
   2 | bb    | 30000
   3 | ccc   | 40000
   4 | ccc   | 40000
   5 | ddfg  | 40000
   6 | nnn   |    -1


4.
create or replace function disp3() returns int as'
declare
a int:=20;
begin
return a;
end;'
language 'plpgsql';

output:

AS=# select disp3();
 disp3 
-------
    20
(1 row)

5. create or replace function disp() returns varchar as'
declare
a varchar(20):=''abc'';
begin
return a;
end;'
language 'plpgsql';


output:

AS=# select disp();
 disp 
------
 abc
(1 row)

6. create or replace function disp1() returns void as'
declare
a int:=20;
b int:=30;
begin
raise notice ''value of a and b:% %'',a,b;
end;'
language 'plpgsql';


Output:

NOTICE:  value of a and b:20 30
 disp1 
-------
 
(1 row)

7. create or replace function f8() returns text as'
declare
r emp1%rowtype;
begin
select into r * from emp1 where eid=1;
return r.eid||'' '' ||r.ename||''  ''||r.esal;
end;'
language 'plpgsql';

output:

AS=# select f8();
      f8      
--------------
 1 aaa  20000
(1 row)

8. create function check_marks() returns trigger as'
begin
if(new.marks<20 or new.marks>=40) then
raise exception ''marks cannot be less than twenty or marks cannot be more then 40'';
end if;
end;'
language 'plpgsql';

CREATE FUNCTION


create trigger t1 after insert or update on std for each row execute procedure check_marks();

CREATE TRIGGER

AS=# create table std(sno int,sname text,marks int);
CREATE TABLE
AS=# insert into std values(1,'abc',50);
INSERT 0 1
AS=# insert into std values(2,'def',40);
INSERT 0 1
AS=# insert into std values(3,'pqr',30);
INSERT 0 1
AS=# select * from std;
 sno | sname | marks 
-----+-------+-------
   1 | abc   |    50
   2 | def   |    40
   3 | pqr   |    30
(3 rows)



Output:

AS=# insert into std values(4,'aaa',10);
ERROR:  marks cannot be less than twenty or marks cannot be more then 40
AS=# insert into std values(5,'aaa',40);
ERROR:  marks cannot be less than twenty or marks cannot be more then 40
AS=# insert into std values(5,'aaa',50);
ERROR:  marks cannot be less than twenty or marks cannot be more then 40



9. create or replace function not_delete1() returns trigger as'
begin
if(old.marks<40)then
raise exception ''not to delete'';
end if;
return old;
end;'
language 'plpgsql';

create trigger t13 before delete or update on std for each row execute procedure not_delete1();

Output:

AS=# select * from std;
 sno | sname | marks 
-----+-------+-------
   1 | abc   |    50
   2 | def   |    40
   3 | pqr   |    30
(3 rows)


AS=# delete from std where sno=3;
ERROR:  not to delete

10. create or replace function emp_sal() returns trigger as'
begin
if(new.esal<0)then
raise exception ''Employee salary should be greater than zero'';
end if;
return new;
end;'
language 'plpgsql';

create trigger t7 after insert or update on emp1 for each row execute procedure emp_sal();

Output:

AS=# select * from emp1;;
 eid | ename | esal  
-----+-------+-------
   1 | aaa   | 20000
   2 | bb    | 30000
   3 | ccc   | 40000
   4 | ccc   | 40000
   5 | ddfg  | 40000
(5 rows)


AS=# insert into emp1 values(7,'ddd',-1);
ERROR:  Employee salary should be greater than zero.

11. create or replace function emp_name() returns trigger as'
begin
if(new.ename!=''abc'' or new.ename!=''pqr'') then
raise exception ''Employee name should be abc or pqr'';
end if;
return new;
end;'
language 'plpgsql';

create trigger t8 after insert or update on emp1 for each row execute procedure emp_name();

Output:

AS=# select * from emp1;;
 eid | ename | esal  
-----+-------+-------
   1 | aaa   | 20000
   2 | bb    | 30000
   3 | ccc   | 40000
   4 | ccc   | 40000
   5 | ddfg  | 40000
(5 rows)


AS=# insert into emp1 values(9,'ggg',2000);
ERROR:  Employee name should be abc or pqr
