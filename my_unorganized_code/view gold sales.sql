create view gold.fact_sales as 
SELECT  [sls_ord_num] order_number 
      ,[sls_prd_key] product_key 
      ,[sls_cust_id] customer_id 
      ,[sls_order_dt] order_date
      ,[sls_ship_dt] ship_date
      ,[sls_due_dt] due_date
      ,[sls_sales] sales_amount
      ,[sls_quantity] quanity
      ,[sls_price] price
      
  FROM [datawarehouse].[silver].[crm_sales_details] sd 
left join gold.dim_products pr 
on sd.sls_prd_key = pr.product_number
left join gold.dim_customer cu 
on sd.sls_cust_id = cu.customer_id