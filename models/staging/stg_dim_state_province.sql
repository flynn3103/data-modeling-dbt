WITH
  dim_state_province__source AS (
    SELECT * 
    FROM `vit-lam-data.wide_world_importers.application__state_provinces`
  ),
  dim_state_province__rename_column AS (
    SELECT
      state_province_id as state_province_key
      ,state_province_code
      ,state_province_name
      ,sales_territory
    FROM
      dim_state_province__source
  ),
  dim_state_province__cast_type AS (
    SELECT
      CAST(state_province_key as INTEGER) as state_province_key
      ,CAST(state_province_code as STRING) as state_province_code
      ,CAST(state_province_name as STRING) as state_province_name
      ,CAST(sales_territory as STRING) as sales_territory
    FROM
      dim_state_province__rename_column
  ),
  dim_state_province__add_undefined_record AS (
    SELECT
      state_province_key
      ,state_province_code
      ,state_province_name
      ,sales_territory
    FROM
      dim_state_province__cast_type
    Union all
    SELECT
      0 as state_province_key
      ,'Undefined' as state_province_code
      ,'Undefined' as state_province_name
      ,'Undefined' as sales_territory
  )

SELECT
      state_province_key
      ,state_province_code
      ,state_province_name
      ,sales_territory
FROM
  dim_state_province__add_undefined_record