create database Facebook

create table categories(
catId int primary key identity(1,1),
description varchar(50)
)

create table comments(
comId int primary key identity(1,1),
postId int foreign key references posts(postId)
)

create table users(
uId int primary key identity(1,1),
uName varchar(50),
city varchar(50),
uDate date )

create table pages(
pageId int primary key identity(1,1),
cId int foreign key references categories(catId),
pageName varchar(50)
)
 
 create table posts(
 postId int primary key identity(1,1),
 uId int foreign key references users(uId),
 text varchar(50),
 postDate date,
 nrShares int )

create table likes (
uId int references users(uId),
pageId int references pages(pageId),
constraint fk_like primary key (uId, pageId),
likeDate date)

insert into users values('Marco Polo','New York','10/10/2010'), ('Geani','Vaslui','02/01/2000')
insert into posts values(2,'text1','02/10/2000',5),(1,'text2','02/10/2001',9)
insert into comments values(2),(1)
insert into categories values('category1'),('category2')
insert into pages values(1,'page1'),(2,'page2')
insert into likes values(1,1,'10/11/2012'),(2,2,'11/11/2019')

select * from users
select * from posts
select * from comments
select * from categories
select * from pages
select * from likes