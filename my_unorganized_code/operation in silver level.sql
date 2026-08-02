
-----check whether it has duplicates / nulls 
 sELECT [prd_info]
      ,count(*)
  FROM [datawarehouse].[bronze].[crm_prd_info]
  group by prd_info 
  having count(*) >1 or prd_info is null

  --------- data standardization & consistency 
  select distinct prd_line from silver.crm_prd_info


  ---check for invalid dates orders
  select * from silver.crm_prd_info 
  where prd_end_dt < prd_start_dt

    
  