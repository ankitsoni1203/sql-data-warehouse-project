CREATE OR ALTER PROCEDURE silver.load_silver
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        ----------------------------------------------------
        -- Clear Existing Data
        ----------------------------------------------------
        TRUNCATE TABLE silver.crm_cust_info;
        TRUNCATE TABLE silver.crm_prd_info;
        TRUNCATE TABLE silver.crm_sales_details;
        TRUNCATE TABLE silver.erp_cust_az12;
        TRUNCATE TABLE silver.erp_loc_a101;
        TRUNCATE TABLE silver.erp_px_cat_g1v2;

        ----------------------------------------------------
        -- CRM CUSTOMER INFO
        ----------------------------------------------------
        INSERT INTO silver.crm_cust_info
        (
            cst_id,
            cst_key,
            cst_firstname,
            cst_lastname,
            cst_gndr,
            cst_material_status,
            cst_create_date
        )
        SELECT
            cst_id,
            TRIM(cst_key),
            TRIM(cst_firstname),
            TRIM(cst_lastname),

            CASE
                WHEN UPPER(TRIM(cst_gndr)) IN ('M','MALE') THEN 'MALE'
                WHEN UPPER(TRIM(cst_gndr)) IN ('F','FEMALE') THEN 'FEMALE'
                ELSE 'N/A'
            END,

            CASE
                WHEN UPPER(TRIM(cst_material_status))='S' THEN 'SINGLE'
                WHEN UPPER(TRIM(cst_material_status))='M' THEN 'MARRIED'
                ELSE 'N/A'
            END,

            cst_create_date
        FROM
        (
            SELECT *,
                   ROW_NUMBER() OVER
                   (
                       PARTITION BY cst_id
                       ORDER BY cst_create_date DESC
                   ) rn
            FROM bronze.crm_cust_info
        ) t
        WHERE rn=1;

        ----------------------------------------------------
        -- CRM PRODUCT INFO
        ----------------------------------------------------
        INSERT INTO silver.crm_prd_info
        (
            prd_info,
            prd_key,
            cat_id,
            prd_nm,
            prd_cost,
            prd_line,
            prd_start_dt,
            prd_end_dt
        )
        SELECT
            prd_info,
            SUBSTRING(prd_key,7,LEN(prd_key)),
            REPLACE(SUBSTRING(prd_key,1,5),'-','_'),
            TRIM(prd_nm),
            ISNULL(prd_cost,0),

            CASE UPPER(TRIM(prd_line))
                WHEN 'M' THEN 'Mountain'
                WHEN 'R' THEN 'Road'
                WHEN 'S' THEN 'Other Sales'
                WHEN 'T' THEN 'Touring'
                ELSE 'N/A'
            END,

            CAST(prd_start_dt AS DATE),

            CAST(
                LEAD(prd_start_dt)
                OVER(PARTITION BY prd_key ORDER BY prd_start_dt)-1
                AS DATE
            )
        FROM bronze.crm_prd_info;

        ----------------------------------------------------
        -- CRM SALES DETAILS
        ----------------------------------------------------
        INSERT INTO silver.crm_sales_details
        (
            sls_ord_num,
            sls_prd_key,
            sls_cust_id,
            sls_order_dt,
            sls_ship_dt,
            sls_due_dt,
            sls_sales,
            sls_quantity,
            sls_price
        )
        SELECT
            sls_ord_num,
            sls_prd_key,
            sls_cust_id,

            CASE
                WHEN sls_order_dt=0 OR LEN(sls_order_dt)<>8
                THEN NULL
                ELSE CAST(sls_order_dt AS DATE)
            END,

            CASE
                WHEN sls_ship_dt=0 OR LEN(sls_ship_dt)<>8
                THEN NULL
                ELSE CAST(sls_ship_dt AS DATE)
            END,

            CASE
                WHEN sls_due_dt=0 OR LEN(sls_due_dt)<>8
                THEN NULL
                ELSE CAST(sls_due_dt AS DATE)
            END,

            CASE
                WHEN sls_sales IS NULL
                     OR sls_sales<=0
                     OR sls_sales<>sls_quantity*ABS(sls_price)
                THEN sls_quantity*ABS(sls_price)
                ELSE sls_sales
            END,

            sls_quantity,

            CASE
                WHEN sls_price IS NULL OR sls_price<=0
                THEN sls_sales/NULLIF(sls_quantity,0)
                ELSE ABS(sls_price)
            END
        FROM bronze.crm_sales_details;

        ----------------------------------------------------
        -- ERP CUSTOMER
        ----------------------------------------------------
        INSERT INTO silver.erp_cust_az12
        (
            CID,
            BDATE,
            GEN
        )
        SELECT

            CASE
                WHEN CID LIKE 'NAS%'
                THEN SUBSTRING(CID,4,LEN(CID))
                ELSE CID
            END,

            CASE
                WHEN BDATE>GETDATE()
                THEN NULL
                ELSE BDATE
            END,

            CASE
                WHEN UPPER(TRIM(GEN)) IN ('F','FEMALE') THEN 'FEMALE'
                WHEN UPPER(TRIM(GEN)) IN ('M','MALE') THEN 'MALE'
                ELSE 'N/A'
            END

        FROM bronze.erp_cust_az12;

        ----------------------------------------------------
        -- ERP LOCATION
        ----------------------------------------------------
        INSERT INTO silver.erp_loc_a101
        (
            CID,
            CNTRY
        )
        SELECT
            REPLACE(CID,'-',''),

            CASE
                WHEN TRIM(CNTRY)='de' THEN 'Germany'
                WHEN TRIM(CNTRY) IN ('us','usa') THEN 'United States'
                WHEN TRIM(CNTRY)='' OR CNTRY IS NULL THEN 'N/A'
                ELSE TRIM(CNTRY)
            END
        FROM bronze.erp_loc_a101;

        ----------------------------------------------------
        -- ERP CATEGORY
        ----------------------------------------------------
        INSERT INTO silver.erp_px_cat_g1v2
        (
            ID,
            CAT,
            SUBCAT,
            MAINTENANCE
        )
        SELECT
            TRIM(ID),
            TRIM(CAT),
            TRIM(SUBCAT),
            TRIM(MAINTENANCE)
        FROM bronze.erp_px_cat_g1v2;

        COMMIT TRANSACTION;

        PRINT 'Silver Layer Loaded Successfully';

    END TRY

    BEGIN CATCH

        ROLLBACK TRANSACTION;

        PRINT ERROR_MESSAGE();

    END CATCH
END;
GO