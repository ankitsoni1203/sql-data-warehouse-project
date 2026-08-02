insert into silver.erp_cust_az12([CID]
      ,[BDATE]
      ,[GEN])
SELECT  
case when cid like 'NAS%' then substring(CID,4,LEN(cid)) 
    else cid 
end cid
, case when BDATE >GETDATE() then null 
else BDATE
end as bdate , 
case when upper (trim (gen )) in ('F' , 'FEMALE') then 'FEMALE'
    when upper (trim (gen )) in ('M' , 'MALE') then 'MALE'
ELSE 'NA' 
END AS gen
   FROM [datawarehouse].[bronze].[erp_cust_az12]


