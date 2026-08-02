
select * from customers , orders
insert into customers values (7,'nothing','abc',600)
select* from customers as c right join orders as o on c.id=o.customer_id