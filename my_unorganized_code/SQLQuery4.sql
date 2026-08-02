create trigger tri_employee on sales.employee  
after insert 
as begin 
insert into sale.employeelogs(employeid , logmessgae , logdate )
	select 
	employeid , 
	'new employee added '+ employeeid ,
	GETDATE()
	from inserted
end 