WITH
  dim_external_stock_item__source AS(
    SELECT *
    FROM `vit-lam-data.wide_world_importers.external__stock_item`
  ),
  dim_external_stock_item__rename_column AS(
    SELECT 
      stock_item_id as stock_item_key
      , category_id as category_key
    FROM
      dim_external_stock_item__source
  ),
  dim_external_stock_item__cast_type AS(
    SELECT
      CAST(stock_item_key as INTEGER) as stock_item_key
      , CAST(category_key as INTEGER) as category_key
    FROM
      dim_external_stock_item__rename_column
  ),
  dim_external_stock_item__add_undefine_record AS(
    SELECT
      stock_item_key
      ,category_key
    FROM
      dim_external_stock_item__cast_type
    Union all 
    SELECT
      0 as stock_item_key
      ,0 as category_key
  )

SELECT
  dim_external_stock_item.stock_item_key
  ,dim_external_stock_item.category_key
  ,COALESCE(dim_external_category.category_name, 'Error') as category_name
  ,COALESCE(dim_external_category.parent_category_key, -1) as parent_category_key
  ,COALESCE(dim_external_category.category_level,-1) as category_level
FROM
  dim_external_stock_item__add_undefine_record as dim_external_stock_item
LEFT JOIN
  {{ref('dim_external_category')}} as dim_external_category
ON
  dim_external_stock_item.category_key = dim_external_category.category_key