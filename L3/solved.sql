-- dirty read
--is. level read uncommitted -> solution read committed

--T1
begin tran
update Sites set site_name = 'Dirty read' where site_id = 1
waitfor delay '00:00:10'
rollback tran

---non repeatable read
-- is. level read committed -> sol repeatable read
insert into Sites(site_name, subscribers) values ('RepSite', 200)
begin tran
waitfor delay '00:00:15'
update Sites set site_name = 'NonRepSite' where site_name='RepSite'
commit tran


---phantom reads
--is level repeatable read -> sol serializable
begin tran
waitfor delay '00:00:05'
insert into Sites(site_name, subscribers) values ('Phantom', 200)
commit tran

---deadlock

begin tran
update Sites set site_name = 'Dead' where site_id = 35
--exclusively lock on Sites
waitfor delay '00:00:10'
--T2 called
update Subscribers set subscriber_name = 'lock' where subscriber_id = 39
commit tran