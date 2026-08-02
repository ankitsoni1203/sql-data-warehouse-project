insert into silver.erp_loc_a101
(CID,CNTRY)

SELECT  replace  (cid,'-' ,'') as cid,
case when trim(CNTRY)='de' then 'Germany'
	when trim(CNTRY) in ('us','usa') then 'united states'
	when trim(CNTRY)='' or CNTRY is null then 'n/a'
		else trim (CNTRY)
		end as cntry
	FROM [datawarehouse].[bronze].[erp_loc_a101]
   


   ------------data standardization & consistency 
   select distinct 
   case when trim(CNTRY)='de' then 'Germany'
	when trim(CNTRY) in ('us','usa') then 'united states'
	when trim(CNTRY)='' or CNTRY is null then 'n/a'
		else trim (CNTRY)
		end as cntry , 
   cntry as old_cntry 
   from bronze.erp_loc_a101
   order by CNTRY
  