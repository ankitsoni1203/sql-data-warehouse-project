
insert into silver.crm_prd_info( prd_info  ,
 prd_key  ,
 cat_id ,
 prd_nm ,
 prd_cost ,
 prd_line        ,
 prd_start_dt      ,
 prd_end_dt       )  
SELECT [prd_info]
      ,
      replace(SUBSTRING(prd_key , 1,5 ) , '-','_' )as cat_id 
      ,SUBSTRING(prd_key , 7,LEN(prd_key) ) as prd_key
      ,[prd_nm],
      isnull(prd_cost,0) as prd_cost
      ,case UPPER(trim(prd_line))
            when 'M' then   'mountain'
            when 'R ' THEN  'road'
            when 's' then 'other sales'
            when 't' then 'touring'
            else 'n/a'
            end as prd_line
      , cast ([prd_start_dt] as date ) as prd_start_date
      ,  cast (lead (prd_start_dt) over (partition by prd_key order by prd_start_dt )-1  as  date )as prd_end_dt_test
      
  FROM [datawarehouse].[bronze].[crm_prd_info]
  