
use Management 
begin tran
update tasks set descrip = 'DirtyRead' where taskId = 1
waitfor delay '00:00:10'
rollback tran