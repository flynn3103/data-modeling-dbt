WITH
  dim_delivery_method__source AS (
    SELECT *
    FROM `vit-lam-data.wide_world_importers.application__delivery_methods`
  ),
  dim_delivery_method__rename_column AS (
    SELECT
      delivery_method_id as delivery_method_key
      , delivery_method_name
    FROM
      dim_delivery_method__source
  ),
  dim_delivery_method__cast_type AS (
    SELECT
      CAST(delivery_method_key as INTEGER) as delivery_method_key
      , CAST(delivery_method_name as STRING) as delivery_method_name
    FROM
      dim_delivery_method__rename_column
  ),
  dim_delivery_method__add_undefined_record AS (
    SELECT
      delivery_method_key
      ,delivery_method_name
    FROM
      dim_delivery_method__cast_type
    Union all
    SELECT
      0 as delivery_method_key
      ,'Undefined' as delivery_method_name
  )

SELECT
  delivery_method_key
  , delivery_method_name
FROM
  dim_delivery_method__add_undefined_record