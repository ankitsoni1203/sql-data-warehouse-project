insert into silver.crm_cust_info( [cst_id]
      ,[cst_key]
      ,[cst_firstname]
      ,[cst_lastname]
      ,[cst_gndr] 
         , cst_material_status
      ,[cst_create_date])
SELECT [cst_id]
      ,[cst_key]
      ,[cst_firstname]
      ,[cst_lastname]
      ,[cst_gndr] 
         , cst_material_status
      ,[cst_create_date]
  FROM ( select *
, ROW_NUMBER() over (partition by cst_id  order by cst_create_date desc ) as flag_last

from bronze.crm_cust_info
) t where flag_last = 1

------ updating the row of table  of crt_material_status and crt_gndr 
/*
select 
cst_id , count(*)
from silver.crm_cust_info
group by cst_id
having count(*) >1 or cst_id is null


-------check duplicate cst_id 






update bronze.crm_cust_info
set 
cst_material_status= case when trim(cst_material_status) = 's' then 'SINGLE'
            when trim(cst_material_status) = 'M' then 'married'
            else 'na'
            end 