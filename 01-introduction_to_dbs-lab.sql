create function f_CalculateTotalBalance (@ClientID int)
returns decimal (15, 2) 
begin
declare @result as decimal (15,2) = (
select sum (Balance)
from accounts where ClientId = @ClientID
)
return @result
end

GO
SELECT dbo.f_CalculateTotalBalance(1) AS Balance
go

create proc p_AddAccount @ClientId int, @AccountTypeId int as
insert into Accounts (ClientId, AccountTypeId)
values (@ClientId, @AccountTypeId)
go

p_AddAccount 2, 2

select * from Accounts

go
create proc p_Deposit @AccountId int, @Amount decimal (15, 2) as
update Accounts
set Balance += @Amount
where Id = @AccountId
go

p_Deposit 17, 1000

go

create proc p_Withdraw @AccountId int, @Amount decimal (15, 2) as
begin
    declare @OldBalance decimal (15,2)
    select @OldBalance = Balance from Accounts where Id = @AccountId
    if (@OldBalance - @Amount >= 0)
    begin
    update Accounts
    set Balance -= @Amount
    where Id = @AccountId
    end
    else
    begin
    raiserror ('Insufficient funds', 10, 1)
    end
end

go


p_Withdraw 17, 100


create table Transactions (
    Id int primary key identity,
    AccountId int foreign key references Accounts(Id),
    OldBalance decimal (15, 2) not null,
    NewBalance decimal (15, 2) not null,
    Amount as NewBalance - OldBalance,
    [DateTime] DATETIME2
)
go


-- triger
create trigger tr_Transaction on Accounts
after update
as
    insert into Transactions (AccountId, OldBalance, NewBalance, [DateTime])
    select inserted.Id, deleted.Balance, inserted.Balance, getdate() from inserted
    join deleted on inserted.Id = deleted.Id

go


p_Deposit 1, 25.00
GO

p_Deposit 1, 40.00
GO

p_Withdraw 2, 200.00
GO

p_Deposit 4, 180.00
GO


SELECT * FROM Transactions