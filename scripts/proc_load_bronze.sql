
/*
Usage Example:
    EXEC bronze.load_bronze;
*/

create or alter  procedure bronze.load_bronze as 
begin
    declare @start_time datetime , @end_time datetime , @batch_start_time datetime , @batch_end_time datetime;
    begin try 
        
        SET @batch_start_time = GETDATE();

        PRINT 'Loading CRM Tables';
        SET @start_time = GETDATE();

        truncate table bronze.crm_cust_info -- no dublicate data by multiple insert 
        bulk insert  bronze.crm_cust_info  from 'C:\Users\Asus\Downloads\sql-data-analytics-project\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\cust_info.csv  '
        with (
        firstrow =2 ,
        fieldterminator =',',
        tablock 
        );

        SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
	

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
        end try 
        begin catch 
        print 'erroe occured during loading bronze layer '
        print'error message ' + error_message();
        PRINT 'Error Message' + CAST (ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error Message' + CAST (ERROR_STATE() AS NVARCHAR);
        end catch 
        
end 
