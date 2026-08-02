truncate table bronze.crm_cust_info -- no dublicate data by multiple insert 
bulk insert  bronze.crm_cust_info  from 'C:\Users\Asus\Downloads\sql-data-analytics-project\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\cust_info.csv  '
with (
firstrow =2 ,
fieldterminator =',',
tablock 
);


truncate table bronze.crm_prd_info -- no dublicate data by multiple insert 
bulk insert  bronze.crm_prd_info  from 'C:\Users\Asus\Downloads\sql-data-analytics-project\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\prd_info.csv  '
with (
firstrow =2 ,
fieldterminator =',',
tablock 
);

truncate table bronze.crm_sales_details -- no dublicate data by multiple insert 
bulk insert  bronze.crm_sales_details  from 'C:\Users\Asus\Downloads\sql-data-analytics-project\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\sales_details.csv  '
with (
firstrow =2 ,
fieldterminator =',',
tablock 
);



truncate table bronze.erp_cust_az12-- no dublicate data by multiple insert 
bulk insert  bronze.erp_cust_az12  from 'C:\Users\Asus\Downloads\sql-data-analytics-project\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\cust_az12.csv  '
with (
firstrow =2 ,
fieldterminator =',',
tablock 
);



truncate table bronze.erp_loc_a101-- no dublicate data by multiple insert 
bulk insert  bronze.erp_loc_a101  from 'C:\Users\Asus\Downloads\sql-data-analytics-project\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\loc_a101.csv  '
with (
firstrow =2 ,
fieldterminator =',',
tablock 
);


truncate table bronze.erp_px_cat_g1v2-- no dublicate data by multiple insert 
bulk insert  bronze.erp_px_cat_g1v2  from 'C:\Users\Asus\Downloads\sql-data-analytics-project\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\px_cat_g1v2.csv  '
with (
firstrow =2 ,
fieldterminator =',',
tablock 
);




 drop table bronze.crm_sales_details
create  table bronze.crm_sales_details (
sls_ord_num nvarchar(50 ),
sls_prd_key nvarchar(50 ),
sls_cust_id nvarchar(50 ),
sls_order_dt nvarchar(50 ),
sls_ship_dt nvarchar(50 ),
sls_due_dt nvarchar(50 ),
sls_sales int ,
sls_quantity int ,  
sls_price int 

)



select count(*) from bronze.crm_cust_info



-- if u insert multiple time 
/*wITH CTE AS
(
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY cst_id, cst_key, cst_firstname, cst_lastname , cst_material_status ,cst_gndr,cst_create_date
               ORDER BY (SELECT NULL)
           ) AS rn
    FROM bronze.crm_cust_info
)
DELETE FROM CTE
WHERE rn > 1; 
 ------------------------------- or-------------------------------- 
  truncate table bronze.crm_cust_info



-- to check the data if multple time 

select cst_id  , count(*) as  cnt from bronze.crm_cust_info group by cst_id having count(*)>1*/ 