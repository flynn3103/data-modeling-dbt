WITH
  dim_delivery_city__source AS (
    SELECT *
    FROM `vit-lam-data.wide_world_importers.application__cities`
  ),
  dim_delivery_city__rename_column AS (
    SELECT
      city_id as city_key
      ,city_name
      ,state_province_id as state_province_key
    FROM
      dim_delivery_city__source
  ),
  dim_delivery_city__cast_type AS (
    SELECT
      CAST(city_key as INTEGER) as city_key
      ,CAST(city_name as STRING) as city_name
      ,CAST(state_province_key as INTEGER) as state_province_key
    FROM
      dim_delivery_city__rename_column
  ),
  dim_delivery_city__add_undefined_record AS (
    SELECT
      city_key
      ,city_name
      ,state_province_key
    FROM
      dim_delivery_city__cast_type
    Union all
    SELECT
      0 as city_key
      ,'Undefined' as city_name
      ,0 as state_province_key
  )

SELECT
      dim_delivery_city.city_key
      ,dim_delivery_city.city_name
      ,dim_delivery_city.state_province_key
      ,COALESCE(dim_state_province.state_province_code,'Error') as state_province_code
      ,COALESCE(dim_state_province.state_province_name,'Error') as state_province_name
      ,COALESCE(dim_state_province.sales_territory,'Error') as sales_territory
FROM
  dim_delivery_city__add_undefined_record as dim_delivery_city
LEFT JOIN
  {{ref('stg_dim_state_province')}} as dim_state_province
On dim_delivery_city.state_province_key = dim_state_province.state_province_key