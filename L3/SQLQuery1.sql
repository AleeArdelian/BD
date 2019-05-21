/*insert into Sites(site_name, subscribers) values
('Amazon', 25000),
('Youtube', 12000),
('News',5000)

insert into Subscribers(subscriber_name, no_follows) values
('Catalin Belcianu', 100),
('Gerlinde Cristine', 654)

select * from Sites
select * from Subscribers


go
*/
create function uf_ValidateName( @name varchar(50) ) returns int as
	begin
	declare @result int
	set @result = 1
	if UNICODE(@name) = UNICODE(LOWER(@name))
		set @result = 0
	return @result
	end
go
create function uf_ValidateIfNumberIsSmallerZero( @number int) returns int as
	begin
	declare @result int
	set @result = 1
	if @number < 0 
		set @result = 0
	return @result
	end
go
create function uf_ValidateRating( @number int) returns int as
	begin
	declare @result int
	set @result = 1
	if @number <= 0 or @number > 5 
		set @result = 0
	return @result
	end
go

create or alter proc usp_AddSiteSubscriber @subscribers int, @site_name varchar(50), @subscriber_name varchar(50), @no_follows int, @rating int as
	begin
		begin try
			begin transaction
				
			if (dbo.uf_ValidateIfNumberIsSmallerZero(@subscribers) <>1 )
				begin
					raiserror('Invalid number of subscribers. The number of subscribers must be greater than 0', 14, 1)
				end
			if (dbo.uf_ValidateIfNumberIsSmallerZero(@no_follows) <> 1)
				begin
					raiserror('Invalid number of follows. The number of follows must be greater than 0', 14, 1)
				end
			if (dbo.uf_ValidateName(@site_name) <> 1)
				begin
					raiserror('Invalid site name. The name must begin with upper case letter', 14, 1)
				end
			if (dbo.uf_ValidateName(@subscriber_name) <> 1)
				begin
					raiserror('Invalid subscriber name. The name must begin with upper case letter', 14, 1)
				end
			if (dbo.uf_ValidateRating(@rating) <> 1)
				begin
					raiserror('Invaild rating. The rating must be between 1 an 5!', 14, 1)
				end
			
			insert into Sites(site_name,subscribers) values (@site_name, @subscribers)
			insert into Subscribers(subscriber_name, no_follows) values (@subscriber_name, @no_follows)
			
			declare @site_id int
			select @site_id = MAX(site_id) from Sites
			declare @subscriber_id int 
			select @subscriber_id = MAX(subscriber_id) from Subscribers

			insert into Site_subscribers(site_id,subscriber_id,rating) values (@site_id, @subscriber_id, @rating)
			
			commit transaction
			select 'Transaction committed'
		end try

		begin catch
			rollback tran
			select 'Rollback transaction'
		end catch
	end
go


create or alter proc usp_AddSiteSubscriber2 @subscribers int, @site_name varchar(50), @subscriber_name varchar(50), @no_follows int, @rating int as
	begin
		begin try
			begin transaction
				if ( dbo.uf_ValidateIfNumberIsSmallerZero(@subscribers) <>1 )
					begin
						raiserror('Invalid number of subscribers. The number of subscribers must be greater than 0', 14, 1)
					end
				if (dbo.uf_ValidateName(@site_name) <> 1)
					begin
						raiserror('Invalid subscriber name. The name must begin with upper case letter', 14, 1)
					end
				insert into Sites(site_name,subscribers) values (@site_name, @subscribers)
				declare @site_id int
				select @site_id = MAX(site_id) from Sites
			commit transaction
			select 'Transaction for sites committed'
		end try
		begin catch
			rollback tran
			select 'Rollback for transaction'
		end catch
		
		begin try
			begin tran
			if (dbo.uf_ValidateIfNumberIsSmallerZero(@no_follows) <> 1)
				begin
					raiserror('Invalid number of follows. The number of follows must be greater than 0', 14, 1)
				end
			if (dbo.uf_ValidateName(@subscriber_name) <> 1)
				begin
					raiserror('Invalid subscriber name. The name must begin with upper case letter', 14, 1)
				end
			insert into Subscribers(subscriber_name, no_follows) values (@subscriber_name, @no_follows)
			
			declare @subscriber_id int 
			select @subscriber_id = MAX(subscriber_id) from Subscribers

			commit transaction
			select 'Transaction for subscribers committed'
		end try
		begin catch
			rollback tran
			select 'Rollback for subscribers'
		end catch

		begin try
			begin tran
				if (dbo.uf_ValidateRating(@rating) <> 1)
					begin
						raiserror('Invaild rating. The rating must be between 1 an 5!', 14, 1)
					end
				insert into Site_subscribers(site_id,subscriber_id,rating) values(@site_id, @subscriber_id, @rating)
			
			commit transaction
			select 'Transaction for site_subscribers committed'
		end try
		begin catch
			rollback tran
			select 'Rollback for site_subscribers'
		end catch
end
go

exec usp_AddSiteSubscriber -8, 'Facebook', 'Ioana Bondoc', 71, 1

exec usp_AddSiteSubscriber2 -1, 'Minimax', 'Denisa Cesha', 88, 5

select * from Sites
select * from Subscribers
select * from Site_subscribers

delete from Sites where site_id >= 28
delete from Subscribers where subscriber_id >= 28