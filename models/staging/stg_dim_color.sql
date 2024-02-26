WITH
  dim_color__source AS (
    SELECT *
    FROM `vit-lam-data.wide_world_importers.warehouse__colors`
  ),
  dim_color__rename_column AS (
    SELECT
      color_id as color_key
      , color_name
    FROM
      dim_color__source
  ),
  dim_color__cast_type AS (
    SELECT
      CAST(color_key as INTEGER) as color_key
      , CAST(color_name as STRING) as color_name
    FROM
      dim_color__rename_column
  ),
  dim_color__add_undefined_record AS (
    SELECT
      color_key
      ,color_name
    FROM
      dim_color__cast_type
    Union all
    SELECT
      0 as color_key
      ,'Undefined' as color_name
  )

SELECT
  color_key
  , color_name
FROM
  dim_color__add_undefined_record