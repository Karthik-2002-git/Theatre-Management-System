
CREATE table T_Admin
(
    Admin_ID varchar(20) PRIMARY KEY,
    admin_Name varchar(20),
    adminPhoneNum varchar(20)
);

CREATE  TABLE Customer
(
    cust_Id VARCHAR(20),
    cust_name VARCHAR(20) NOT NULL,
    cust_phone VARCHAR(10) ,
    cust_age INT,
    PRIMARY KEY(cust_Id)
);
Create TABLE Seat
(
    seat_type VARCHAR(20),
    seat_no int PRIMARY KEY,
    check(seat_type in ('premium','elite','budget'))
);
create table Movie
(
    movie_name VARCHAR(20) PRIMARY KEY,
    actor VARCHAR(20),
    IMDB_rating DECIMAL(2),
    runtime int,
    
    certificate varchar(3),
    check(certificate = 'U' or certificate = 'U/A' or certificate = 'A' or certificate = 'S'),
    check(IMDB_rating <= 5 and IMDB_rating >= 0)
);

CREATE TABLE Screens
(
    screen_No int PRIMARY KEY,
    projector_type VARCHAR(20),
    sound_system VARCHAR(20),
    check(screen_No >= 1 and screen_No <=4),
    check(projector_type in('4k','3d')),
    check(sound_system in('dolby atmos 8.1','dts','qube'))
);

create TABLE Shows
(
    show_ID VARCHAR(20),
    showTime TIMESTAMP unique,
    movie_name VARCHAR(20),
    screen_No int,
    noOfSeats int,
    PRIMARY KEY(show_ID),
    foreign key(movie_name) references Movie(movie_name),
    foreign key(screen_No) references Screens(screen_No)
    
);
---

    
create TABLE Ticket
(
    Ticket_ID varchar(20),
    movie_name varchar(20),
    seat_no int,
    showTime TIMESTAMP,
    screen_no int,
    cust_Id VARCHAR(20),
    bookingTime TIMESTAMP,
    bookingId VARCHAR(20),
    --showId varchar(20),
    foreign key(cust_Id) references Customer(cust_Id),
    foreign key(seat_no) references Seat(seat_no),
    foreign key(movie_name) references Movie(movie_name),
    FOREIGN KEY(showTime) references Shows(showTime),
    FOREIGN KEY(screen_no) REFERENCES Screens(screen_no),
    PRIMARY KEY(Ticket_ID)
);

create table Reviews
(
    cust_ID VARCHAR(20),
    movie_name VARCHAR(20),
    custRatings DECIMAL(2,1),
    FOREIGN KEY(cust_ID) REFERENCES Customer(Cust_Id),
    foreign key(movie_name) references Movie(movie_name)
    
);

    
CREATE TABLE Sells
(
    ticket_ID VARCHAR(20),
    Admin_Id varchar(20),
    FOREIGN KEY(ticket_Id) REFERENCES Ticket(Ticket_ID),
    foreign KEY(Admin_Id) REFERENCES T_Admin(Admin_ID)
);

create TABLE Offer
(
    Ticket_ID VARCHAR(20),
    offerName VARCHAR(20),
    discount_percent decimal(2),
    FOREIGN KEY(Ticket_Id) REFERENCES Ticket(Ticket_ID),
    PRIMARY KEY(Ticket_ID,offerName)
);
CREATE TABLE show_has_seat
(
    seat_no int,
    show_ID VARCHAR(20),
    FOREIGN KEY(seat_no) REFERENCES Seat(seat_no),
    FOREIGN KEY(show_ID) REFERENCES Shows(show_ID)
);

    
set serverOutput on;

create or replace function MovieAgent
return varchar IS
    inptMname varchar(20);
    inptActor varchar(20);
    inptIMDB decimal(2);
    inptRuntime TIMESTamp;
    certificate varchar(20);
    ret varchar(20) := 'SUCCESS';
    oneforagainZEROforexit int;
begin
    dbms_output.put_line('YOU HAVE ENTERED AS MOVIE AGENT ENTER THE FOLLOWING DETAILS');
    inputMname := '&inptMname';
    inputActor := '&inptActor';
    inputIMDB := '&inputIMDB';
    inptRuntime := '&ENTER_RUNTIME_OF_MOVIE';
    certificate := '&certificate';
    insert into Movie values(inputActor,inputMname,inputIMDB,inptRuntime,certificate);
    oneforagainZEROforexit := &zero_to_exit_one_for_again;
    if(oneforagainZEROforexit = 1)then
    MovieAgent();
    else
    
    
    return ret;
end;
    
create sequence log_ID start with 1 increment by 1;
create table accessLog(
    serialNo int,
    loggedIN varchar(20),
    loggedintime timestamp,
    operation varchar(2100)

    );
        


set serveroutput on;
create or replace function managerAdmin
return varchar
is
    input_AdminID varchar(20) ;
    input_adminName varchar(20);
    input_adminPhoneNum varchar(20);
    scss varchar(20);
    currDt TIMESTAMP;
begin
    SELECT TO_CHAR(Sysdate, 'MM-DD-YYYY HH:MM:SS') AS Alias_Name into currDt
FROM Dual ;
    DBMS_OUTPUT.PUT_LINE('YOU HAVE LOGGED IN AS MANAGER AT '||currDt);
    
    input_AdminID := '&ADMIN_ID';
    input_adminName := '&ADMIN_NAME';
    input_adminPhoneNum := '&ADMIN_PHONE_NUMBER';
    insert into T_Admin values(input_AdminID ,input_adminName,input_adminPhoneNum);
    scss := 'SUCCESS';
    return scss;
end;
    
        


declare
    inputRole varchar(20);
    scss varchar(20);
BEGIN
    inputRole := '&MANAGERORADMIN?';
    if(inputRole in('MANAGER','manager','MNG00R') )then
    scss := managerAdmin();
    end if;
END;





----SEAT INSERTION
Declare 
v int;

begin
v:=1;
FOR v in 1..51
loop
insert into Seat values('elite',v);

end loop;
end;
----
Declare 
v int;

begin
FOR v in 51..100
loop
insert into Seat values('premium',v);

end loop;
end;
----

Declare 
v int;

begin
FOR v in 101..150
loop
insert into Seat values('budget',v);

end loop;
end;
----

--SELECT * FROM Movie;
select * from T_Admin;
select * from Seat;
delete from Movie where Movie_name='Simba';


END;

----admin login
set serveroutput on;
declare
    inptAdminID varchar(20);
    inptAdminName varchar(20);
    variable2 varchar(20);
    
    scss varchar(20);
BEGIN
    inptAdminID := '&ENTER_ADMIN_ID';
    inptAdminName := '&ENTER_ADMIN_NAME';
    select admin_Name into variable2 from T_Admin where Admin_ID = inptAdminID;
    IF(inptAdminName = variable2 )then
        dbms_output.put_line('SUCCESS');

    else
    dbms_output.put_line('INVALID CRED');
    END IF;
  
END;

--movieAgent

set serveroutput on;
declare

    inpt_movie_name VARCHAR(20);
    inpt_actor VARCHAR(20);
    inpt_IMDB_rating DECIMAL(2);
    inpt_runtime int;
    inpt_certificate varchar(3);
                
BEGIN
    

       inpt_movie_name :='&MOVIE_NAME';
       inpt_actor := '&ACTOR_NAME';
       inpt_IMDB_rating := '&IMDB';
       inpt_runtime := '&RUNTIME_IN_MINS';
       inpt_certificate := '&CERTIFICATE';
       
       insert into Movie values(inpt_movie_name,inpt_actor,inpt_IMDB_rating,inpt_runtime,inpt_certificate);
end    



insert into T_Admin values('ADM001','RAMANAN','100001000');
insert into T_Admin values('ADM002','RUBAN','100033000');
insert into T_Admin values('ADM003','RYDHAHMED','100901000');
insert into T_Admin values('ADM004','SARAN','100001067');
insert into T_Admin values('ADM005','SENTHIL','134001000');
insert into T_Admin values('ADM006','SOORIYA','108901000');


insert into Customer values('CUST001','BHIMBOY','96996996',23);
insert into Customer values('CUST002','RAAJU','96923496',13);
insert into Customer values('CUST003','RAJAN','96923296',20);
insert into Customer values('CUST004','MANDESH','91296996',22);
insert into Customer values('CUST005','SATTIROY','45556996',24);
insert into Customer values('CUST006','FAZAL','96949856',27);
insert into Customer values('CUST007','AZAL','96232296',33);
insert into Customer values('CUST008','ZAROOR','96886996',89);
insert into Customer values('CUST009','GOPI','96993496',32);
insert into Customer values('CUST010','UTTHAM','92366996',73);
insert into Customer values('CUST011','BABOO','96996996',29);
insert into Customer values('CUST012','MIA','96991096',63);
insert into Customer values('CUST013','KHALIFA','90996996',43);
insert into Customer values('CUST014','ASTUL','96346996',73);
insert into Customer values('CUST015','AZAR','969309996',20);
insert into Customer values('CUST016','JAHANGEER','44996996',12);
insert into Customer values('CUST017','MEENA','96994596',54);
insert into Customer values('CUST018','SHWETA','96956996',34);
insert into Customer values('CUST019','BUPPAN','969565996',12);
insert into Customer values('CUST020','FANDO','96996566',45);
insert into Customer values('CUST021','ASTROCATES','94596996',45);
--------

insert into Customer values('CUST022','ASAN','94596996',35);
insert into Customer values('CUST023','RASOOL','954367736',23);
insert into Customer values('CUST024','SEEMAM','9422122',34);
insert into Customer values('CUST025','JULEE','94593322',55);
insert into Customer values('CUST026','REETU','94596322',90);
insert into Customer values('CUST027','MANI','945962334',12);
insert into Customer values('CUST028','MEENAPAAN','94591121',75);
insert into Customer values('CUST029','KANAVAKARUPPAN','9111232',25);
insert into Customer values('CUST030','AATHAMBAL','3242342',95);
insert into Customer values('CUST031','ATHIMBEL','94523423',45);
insert into Customer values('CUST032','GOSWAMY','94596433',55);


insert into Screens values(1,'4k','dolby atmos 8.1');
insert into Screens values(2,'4k','dts');
insert into Screens values(3,'3d','qube');
insert into Screens values(4,'3d','dolby atmos 8.1');


INSERT INTO Movie VALUES('JILLA','VISAY',1.2,110,'A');
INSERT INTO Movie VALUES('BILLA','ASAY',4.9,120,'U');
INSERT INTO Movie VALUES('BILLA2','ASAY',2.3,125,'U/A');
INSERT INTO Movie VALUES('KO','JEEVA',3.5,150,'U/A');
INSERT INTO Movie VALUES('NORTH MADRAS','MULTIPLE STARS',5,145,'A');
INSERT INTO Movie VALUES('VISHWAROOM','ANDAVAR',0.2,180,'U/A');
INSERT INTO Movie VALUES('TAMILFILM','MULTIPLE STARS',3.4,110,'U/A');
INSERT INTO Movie VALUES('DJANGO-TAM','LEO',5,175,'A');
INSERT INTO Movie VALUES('INCEPTION-TAM','LEO',4.9,120,'U/A');
INSERT INTO Movie VALUES('A TIME IN HOLLYWOOD','LEO',4.9,125,'A');
INSERT INTO Movie VALUES('AVENGERS-3-TAM','MULTIPLE STARS',4.9,130,'U/A');
INSERT INTO Movie VALUES('THE FAST SAGA','DWYANE',4.9,135,'U/A');



insert into Shows values('SH001',TIMESTAMP '2021-12-01 12:00:00','KO',1,150);
insert into Shows values('SH002',TIMESTAMP '2021-12-01 13:00:00','BILLA2',2,150);
insert into Shows values('SH003',TIMESTAMP '2021-12-02 17:00:00','BILLA',1,150);
insert into Shows values('SH004',TIMESTAMP '2021-12-03 17:30:00','NORTH MADRAS',3,150);
insert into Shows values('SH005',TIMESTAMP '2021-12-04 10:30:00','TAMILFILM',3,150);
insert into Shows values('SH006',TIMESTAMP '2021-12-04 12:30:00','NORTH MADRAS',2,150);
insert into Shows values('SH007',TIMESTAMP '2021-12-04 17:30:00','NORTH MADRAS',3,150);



select * from Shows;

insert into Ticket values('T001','KO',150,TIMESTAMP '2021-12-01 12:00:00',1,'CUST001',CURRENT_TIMESTAMP,'B001');
insert into Ticket values('T002','KO',149,TIMESTAMP '2021-12-01 12:00:00',1,'CUST004',CURRENT_TIMESTAMP,'B001');
insert into Ticket values('T003','KO',148,TIMESTAMP '2021-12-01 12:00:00',1,'CUST021',CURRENT_TIMESTAMP,'B002');
insert into Ticket values('T004','KO',147,TIMESTAMP '2021-12-01 12:00:00',1,'CUST011',CURRENT_TIMESTAMP,'B002');
INSERT INTO TICKET VALUES('T005','NORTH MADRAS',146,TIMESTAMP '2021-12-03 17:30:00',3,'CUST019',CURRENT_TIMESTAMP,'B005');

INSERT INTO TICKET VALUES('T006','NORTH MADRAS',80,TIMESTAMP '2021-12-03 17:30:00',3,'CUST019',CURRENT_TIMESTAMP,'B005');
INSERT INTO TICKET VALUES('T009','NORTH MADRAS',81,TIMESTAMP '2021-12-03 17:30:00',3,'CUST020',CURRENT_TIMESTAMP,'B077');
INSERT INTO TICKET VALUES('T010','NORTH MADRAS',82,TIMESTAMP '2021-12-03 17:30:00',3,'CUST021',CURRENT_TIMESTAMP,'B805');
INSERT INTO TICKET VALUES('T011','NORTH MADRAS',66,TIMESTAMP '2021-12-03 17:30:00',3,'CUST019',CURRENT_TIMESTAMP,'B905');
INSERT INTO TICKET VALUES('T012','NORTH MADRAS',67,TIMESTAMP '2021-12-03 17:30:00',3,'CUST024',CURRENT_TIMESTAMP,'B095');
INSERT INTO TICKET VALUES('T013','NORTH MADRAS',8,TIMESTAMP '2021-12-03 17:30:00',3,'CUST016',CURRENT_TIMESTAMP,'B085');
----
INSERT INTO TICKET VALUES('T014','BILLA2',9,TIMESTAMP '2021-12-01 13:00:00',3,'CUST027',CURRENT_TIMESTAMP,'B085');
INSERT INTO TICKET VALUES('T015','BILLA2',10,TIMESTAMP '2021-12-01 13:00:00',3,'CUST028',CURRENT_TIMESTAMP,'B085');
INSERT INTO TICKET VALUES('T016','BILLA2',11,TIMESTAMP '2021-12-01 13:00:00',3,'CUST029',CURRENT_TIMESTAMP,'B085');
INSERT INTO TICKET VALUES('T017','NORTH MADRAS',22,TIMESTAMP '2021-12-03 17:30:00',3,'CUST006',CURRENT_TIMESTAMP,'B085');
INSERT INTO TICKET VALUES('T018','NORTH MADRAS',8,TIMESTAMP '2021-12-03 17:30:00',3,'CUST026',CURRENT_TIMESTAMP,'B085');
INSERT INTO TICKET VALUES('T019','NORTH MADRAS',8,TIMESTAMP '2021-12-03 17:30:00',3,'CUST003',CURRENT_TIMESTAMP,'B085');
INSERT INTO TICKET VALUES('T020','NORTH MADRAS',8,TIMESTAMP '2021-12-03 17:30:00',3,'CUST007',CURRENT_TIMESTAMP,'B085');
INSERT INTO TICKET VALUES('T021SPL','JILLA',51,TIMESTAMP '2021-12-05 12:00:00',3,'SPLCUST001',CURRENT_TIMESTAMP,'B005');
INSERT INTO TICKET VALUES('T022','THE FAST SAGA',150,TIMESTAMP '2021-12-05 17:30:00',3,'CUST026',CURRENT_TIMESTAMP,'B085');
INSERT INTO TICKET VALUES('T023','THE FAST SAGA',149,TIMESTAMP '2021-12-05 17:30:00',3,'CUST040',CURRENT_TIMESTAMP,'B085');
INSERT INTO TICKET VALUES('T024','THE FAST SAGA',148,TIMESTAMP '2021-12-05 17:30:00',3,'CUST041',CURRENT_TIMESTAMP,'B085');
INSERT INTO TICKET VALUES('T025','THE FAST SAGA',147,TIMESTAMP '2021-12-05 17:30:00',3,'CUST038',CURRENT_TIMESTAMP,'B085');
INSERT INTO TICKET VALUES('T026','THE FAST SAGA',146,TIMESTAMP '2021-12-05 17:30:00',3,'CUST037',CURRENT_TIMESTAMP,'B085');
INSERT INTO TICKET VALUES('T027','THE FAST SAGA',145,TIMESTAMP '2021-12-05 17:30:00',3,'CUST033',CURRENT_TIMESTAMP,'B085');
INSERT INTO TICKET VALUES('T028','THE FAST SAGA',144,TIMESTAMP '2021-12-05 17:30:00',3,'CUST034',CURRENT_TIMESTAMP,'B085');
INSERT INTO TICKET VALUES('T029','THE FAST SAGA',143,TIMESTAMP '2021-12-05 17:30:00',3,'CUST035',CURRENT_TIMESTAMP,'B085');
INSERT INTO TICKET VALUES('T030','THE FAST SAGA',142,TIMESTAMP '2021-12-05 17:30:00',3,'CUST036',CURRENT_TIMESTAMP,'B085');
INSERT INTO TICKET VALUES('T040','THE FAST SAGA',100,TIMESTAMP '2021-12-05 17:30:00',3,'CUST002',CURRENT_TIMESTAMP,'B085');
INSERT INTO TICKET VALUES('T042','THE FAST SAGA',101,TIMESTAMP '2021-12-05 17:30:00',3,'CUST010',CURRENT_TIMESTAMP,'B085');
INSERT INTO TICKET VALUES('T043','THE FAST SAGA',111,TIMESTAMP '2021-12-05 17:30:00',3,'CUST007',CURRENT_TIMESTAMP,'B085');
INSERT INTO TICKET VALUES('T044','THE FAST SAGA',15,TIMESTAMP '2021-12-05 17:30:00',3,'CUST026',CURRENT_TIMESTAMP,'B085');
INSERT INTO TICKET VALUES('T045','THE FAST SAGA',10,TIMESTAMP '2021-12-05 17:30:00',3,'CUST026',CURRENT_TIMESTAMP,'B085');
INSERT INTO TICKET VALUES('T046','THE FAST SAGA',122,TIMESTAMP '2021-12-05 17:30:00',3,'CUST012',CURRENT_TIMESTAMP,'B085');
INSERT INTO TICKET VALUES('T047','THE FAST SAGA',123,TIMESTAMP '2021-12-05 17:30:00',3,'CUST016',CURRENT_TIMESTAMP,'B085');
INSERT INTO TICKET VALUES('T048','THE FAST SAGA',11,TIMESTAMP '2021-12-05 17:30:00',3,'CUST036',CURRENT_TIMESTAMP,'B085');
INSERT INTO TICKET VALUES('T049','THE FAST SAGA',12,TIMESTAMP '2021-12-05 17:30:00',3,'CUST051',CURRENT_TIMESTAMP,'B085');
INSERT INTO TICKET VALUES('T050','THE FAST SAGA',1,TIMESTAMP '2021-12-05 17:30:00',3,'CUST076',CURRENT_TIMESTAMP,'B085');



insert into Reviews values('CUST001','KO',3.5);
insert into Reviews values('CUST004','KO',4.3);
insert into Reviews values('CUST021','KO',3.5);
insert into Reviews values('CUST011','KO',3.7);
insert into Reviews values('CUST019','NORTH MADRAS',4.3);

    
insert into show_has_seat values(150,'SH001');
insert into show_has_seat values(149,'SH001');
insert into show_has_seat values(148,'SH001');
insert into show_has_seat values(147,'SH001');

--1
set serveroutput on;
DECLARE
    c int;
BEGIN
    c:=0;
    FOR R in(select * from Customer where cust_age<=15)
    Loop
        c:=c+1;
    end loop;
    dbms_output.put_line('Customers eligible for U films = '||c);
end;

--2
select cust_Id,cust_name from Customer inner join Ticket using(cust_ID) inner join Offer using(Ticket_ID) where offerName='OpeningOffer';


--3
set serveroutput on;
DECLARE
     
    Minpt varchar(20);
BEGIN
    Minpt:='&Movie_Name';
    dbms_output.put_line('Following slots are available : ');
    for r in (select showTime from Shows where movie_name=Minpt and showTime>CURRENT_TIMESTAMP)
    loop
    dbms_output.put_line(r.showTime);
    end loop;
end;

--4
select * from Reviews R inner join Shows S on R.movie_name=S.movie_name where R.custRatings=(select avg(R.custRatings) from reviews group by R.movie_name order by avg(R.custRatings) where ROWNUM=1);
select avg(R.custRatings) from reviews R group by R.movie_name;
--5
set serveroutput on;
BEGIN
for c in (select movie_name from Movie where IMDB_rating = &IMDB_RATING )
LOOP
    DBMS_output.put_line(c.movie_name);
end loop;
end;

--6
create or replace trigger check2 after insert on Ticket
for each row
begin 
update Shows set noOfSeats = noOfSeats - 1
where
movie_name=:new.movie_name;
end;

create table Reviews
(
    cust_ID VARCHAR(20),
    movie_name VARCHAR(20),
    custRatings DECIMAL(2),
    FOREIGN KEY(cust_ID) REFERENCES Customer(Cust_Id),
    foreign key(movie_name) references Movie(movie_name)
    
);

--7
select C.CUST_NAME, C.CUST_AGE FROM CUSTOMER C INNER JOIN TICKET T ON C.CUST_ID = T.CUST_ID INNER JOIN MOVIE M ON T.MOVIE_NAME=M.MOVIE_NAME WHERE M.CERTIFICATE='A' AND C.CUST_AGE>=18; 

--8

CREATE OR REPLACE TRIGGER CHECK_AGE BEFORE INSERT ON TICKET
FOR EACH ROW
DECLARE
AGE INT;
CERT VARCHAR(3);
BEGIN
SELECT CUST_AGE INTO AGE FROM CUSTOMER WHERE CUST_ID=:NEW.CUST_ID;
SELECT CERTIFICATE INTO CERT FROM MOVIE WHERE MOVIE_NAME=:NEW.MOVIE_NAME;
IF AGE<18 AND CERT='A' THEN
RAISE_APPLICATION_ERROR(-20001,'AGE CONSTRAINT NOT SATISFIED');
END IF;
END;

--9
CREATE OR REPLACE TRIGGER CHECK_BDATE BEFORE INSERT ON TICKET
FOR EACH ROW
DECLARE
    M_NAME VARCHAR(20);
    MOVIE VARCHAR(20);
    ST TIMESTAMP;
    CURSOR C IS (SELECT MOVIE_NAME,SHOWTIME FROM TICKET);

BEGIN
    M_NAME:='&MOVIE_NAME';
    OPEN C;
    LOOP 
    FETCH C INTO MOVIE,ST;
    EXIT WHEN C%NOTFOUND;
    IF (M_NAME=MOVIE) THEN
        IF current_timestamp > ST THEN
            RAISE_APPLICATION_ERROR(-20001,'TIME CONSTRAINT NOT SATISFIED');
    END IF;
    END IF;
    END LOOP;
    CLOSE C;
    END;


    --to_char(to_date(test1,'mm/dd/yyyy hh:mi:ss am'),'hh24:mi:ss')
    
--10
declare 
m_input varchar(20);
begin
--m_input:='&Movie_name';
SELECT COUNT(*) FROM TICKET WHERE MOVIE_NAME='&Movie_name';
END;