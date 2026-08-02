insert into silver.erp_px_cat_g1v2 ([ID]
      ,[CAT]
      ,[SUBCAT]
      ,[MAINTENANCE])

SELECT  [ID]
      ,[CAT]
      ,[SUBCAT]
      ,[MAINTENANCE]
  FROM [datawarehouse].[bronze].[erp_px_cat_g1v2]



  --------check for unwanted space 
  select * from bronze.erp_px_cat_g1v2 
  where id != trim(ID) or SUBCAT != TRIM(SUBCAT) OR CAT != TRIM(CAT ) OR MAINTENANCE != TRIM(MAINTENANCE)

  -------------- DATA STANDARDIZATION & CONSISTENCY --
  SELECT DISTINCT CAT FROM bronze.erp_px_cat_g1v2


  select * from silver.erp_px_cat_g1v2
  hj