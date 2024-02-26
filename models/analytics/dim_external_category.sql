WITH
  dim_external_category__source AS(
    SELECT *
    FROM `vit-lam-data.wide_world_importers.external__categories`
  ),
  dim_external_category__rename_column AS(
    SELECT 
      category_id as category_key
      ,category_name
      ,parent_category_id as parent_category_key
      ,category_level 
    FROM
      dim_external_category__source
  ),
  dim_external_category__cast_type AS(
    SELECT
      CAST(category_key as INTEGER) as category_key
      ,CAST(category_name as STRING) as category_name
      ,CAST(parent_category_key as INTEGER) as parent_category_key
      ,CAST(category_level as INTEGER) as category_level
    FROM
      dim_external_category__rename_column
  ),
  dim_external_category__add_undefine_record AS(
    SELECT
      category_key
      ,category_name
      ,parent_category_key
      ,category_level
    FROM
      dim_external_category__cast_type
    Union all 
    SELECT
      0 as category_key
      ,'Undefined' as category_name
      ,-2 as parent_category_key
      ,-2 as category_level
  )

SELECT
  category_key
  ,category_name
  ,parent_category_key
  ,category_level
FROM
  dim_external_category__add_undefine_record