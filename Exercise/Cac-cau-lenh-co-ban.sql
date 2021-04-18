-- if else
declare @dow int
declare @open bit, @process bit

-- get the day of week
set @dow = DATEPART(dw, GetDate());

-- open for business today?
if @dow = 1 or @dow = 7
begin
	select @open = 0, @process = 0
end
else
begin
	select @open = 1, @process = 1
end

print @open
print convert(varchar, @process) + '2'


-- while
go
declare @counter int
declare @str varchar(30)
set  @str = ''
set @counter = 1
while @counter <= 10
begin
	set @str = @str + ' ' + convert(varchar, @counter)
	set @counter = @counter + 1
end
print @str
--