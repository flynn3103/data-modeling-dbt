WITH dim_is_order_finalized AS (
  SELECT 
    'Order is finalized' as is_order_finalized
  UNION ALL
  SELECT
    'Order is not finalized' as is_order_finalized
),
  dim_is_order_line_finalized AS (
  SELECT 
    'Order line is finalized' as is_order_line_finalized
  UNION ALL
  SELECT
    'Order line is not finalized' as is_order_line_finalized
),
  dim_is_order_finalized__join as (
  SELECT
    *
  FROM 
    dim_is_order_finalized
  CROSS JOIN dim_is_order_line_finalized
  CROSS JOIN {{ ref('dim_package_type') }} AS dim_package_type
)

SELECT 
  is_order_line_finalized
  ,is_order_finalized
  ,package_type_key
  ,package_type_name
  ,FARM_FINGERPRINT(
    CONCAT(
    is_order_line_finalized
    ,is_order_finalized
    ,package_type_key
    )
    )
    AS purchase_order_line_indicator_key
FROM 
  dim_is_order_finalized__join
