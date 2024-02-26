WITH
  dim_buying_group__source AS (
    SELECT *
    FROM `vit-lam-data.wide_world_importers.sales__buying_groups`
  ),
  dim_buying_group__rename_column AS (
    SELECT
      buying_group_id as buying_group_key
      , buying_group_name
    FROM
      dim_buying_group__source
  ),
  dim_buying_group__cast_type AS (
    SELECT
      CAST(buying_group_key as INTEGER) as buying_group_key
      , CAST(buying_group_name as STRING) as buying_group_name
    FROM
      dim_buying_group__rename_column
  ),
  dim_buying_group__add_undefined_record AS (
    SELECT
      buying_group_key
      ,buying_group_name
    FROM
      dim_buying_group__cast_type
    Union all
    SELECT
      0 as buying_group_key
      ,'Undefined' as buying_group_name
  )

SELECT
  buying_group_key
  , buying_group_name
FROM
  dim_buying_group__add_undefined_record