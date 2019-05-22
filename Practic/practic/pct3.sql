SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
begin tran
select * from tasks
waitfor delay '00:00:15'
select * from tasks
commit tran


--solved
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
begin tran
select * from tasks
waitfor delay '00:00:15'
select * from tasks
commit tran 