WITH
  dim_customer_category__source AS(
    SELECT *
    FROM `vit-lam-data.wide_world_importers.sales__customer_categories`
  ),
  dim_customer_category__rename_column AS(
    SELECT 
      customer_category_id as customer_category_key
      , customer_category_name
    FROM
      dim_customer_category__source
  ),
  dim_customer_category__cast_type AS(
    SELECT
      CAST(customer_category_key as INTEGER) as customer_category_key
      , CAST(customer_category_name as STRING) as customer_category_name
    FROM
      dim_customer_category__rename_column
  ),
  dim_customer_category__add_undefine_record AS(
    SELECT
      customer_category_key
      ,customer_category_name
    FROM
      dim_customer_category__cast_type
    Union all 
    SELECT
      0 as customer_category_key
      ,'Undefined' as customer_category_name
  )

SELECT
  customer_category_key
  , customer_category_name
FROM
  dim_customer_category__add_undefine_record