create database Management

create table categories(
catId int primary key identity(1,1),
pdescription varchar(50) )

create table projects (
projId int primary key identity(1,1),
pname varchar(50),
teamLead varchar(50),
cId int foreign key references categories(catId))

create table developers(
devId int primary key identity(1,1),
projId int foreign key references projects(projId),
ddate date,
dname varchar(50),
age int,
nrYears int)

create table tasks(
taskId int primary key identity(1,1),
descrip varchar(50),
tdate date,
devId int foreign key references developers(devId),)

create table feature(
fid int primary key identity(1,1),
taskId int foreign key references tasks(taskId),
fname varchar(50),
estimation int)


insert into categories values ('cat4'),( 'cat5')
insert into projects values( 'projName3','lea4',3),('projname4','lead5',4)
insert into developers values ( 3,'10/11/2000','deme',22,3), (4,'11/11/2011','defs',67,40)
insert into tasks values ('task3','10/10/2010',1),('task4', '11/11/2011',2),('t3','10/12/2012',7)
insert into feature values (1,'f1',3),(2,'f2',5),(3,'f3',10)


select * from projects
select * from developers
select * from tasks








