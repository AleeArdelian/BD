--dirty read unresolved
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
begin tran
select * from Sites
waitfor delay '00:00:15'
select * from Sites
commit tran 

--solved
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
begin tran
select * from Sites
waitfor delay '00:00:15'
select * from Sites
commit tran 
---------
--no repeatable read
--unsolved
set transaction isolation level read committed
begin tran
select * from Sites
waitfor delay '00:00:15'
select * from Sites
commit tran

--solved
set transaction isolation level repeatable read
begin tran
select * from Sites
waitfor delay '00:00:15'
select * from Sites
commit tran

---phantom read
--unsolved
set transaction isolation level repeatable read
begin tran 
select * from Sites
waitfor delay '00:00:06'
select * from Sites
commit tran

--solved
set transaction isolation level serializable
begin tran 
select * from Sites
waitfor delay '00:00:06'
select * from Sites
commit tran

-----deadlock
--unsolved
begin tran
update Subscribers set subscriber_name ='lock 2' where subscriber_id=39
waitfor delay '00:00:10'
--has ex lock on Subscribers
update Sites set site_name = 'Dead 2' where site_id = 35
--blocked by T1, both are blocked in T1 and T2
commit tran
--T2 will be terminated as deadlock victim and all values remain from T1

--solved
set deadlock_priority HIGH
begin tran
update Subscribers set subscriber_name ='lock 2' where subscriber_id=39
waitfor delay '00:00:10'
update Sites set site_name = 'Dead 2' where site_id = 35
commit tran
--T1 will be terminated as deadlock victim and all values remain from T2
