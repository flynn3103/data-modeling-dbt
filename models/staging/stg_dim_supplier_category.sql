WITH
  dim_supplier_category__source AS(
    SELECT *
    FROM `vit-lam-data.wide_world_importers.purchasing__supplier_categories`
  ),
  dim_supplier_category__rename_column AS(
    SELECT 
      supplier_category_id as supplier_category_key
      , supplier_category_name
    FROM
      dim_supplier_category__source
  ),
  dim_supplier_category__cast_type AS(
    SELECT
      CAST(supplier_category_key as INTEGER) as supplier_category_key
      , CAST(supplier_category_name as STRING) as supplier_category_name
    FROM
      dim_supplier_category__rename_column
  ),
  dim_supplier_category__add_undefine_record AS(
    SELECT
      supplier_category_key
      ,supplier_category_name
    FROM
      dim_supplier_category__cast_type
    Union all 
    SELECT
      0 as supplier_category_key
      ,'Undefined' as supplier_category_name
  )

SELECT
  supplier_category_key
  , supplier_category_name
FROM
  dim_supplier_category__add_undefine_record