alter  procedurE getcustomersummary @country nvarchar (50 )  = 'usa'as 
begin 
declare @totalcustomer int , @avgscore float ;

select 

@totalcustomer = count(*)   ,@avgscore= avg(score)  from customers where country = @country ;

print 'total customer from ' +@country +':' +  cast (@totalcustomer as nvarchar);
print 'avg score  from '+@country +':' + cast (@avgscore as nvarchar);
end 


exec getcustomersummary @country = 'germany'