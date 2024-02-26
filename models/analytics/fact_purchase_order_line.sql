WITH 
  fact_purchase_order_line__source as (
    SELECT
      *
    FROM 
      `vit-lam-data.wide_world_importers.purchasing__purchase_order_lines`
    ),
  fact_purchase_order_line__rename_column as (
    SELECT
      purchase_order_line_id as purchase_order_line_key
      ,description
      ,purchase_order_id as purchase_order_key
      ,stock_item_id as product_key
      ,package_type_id as package_type_key
      ,ordered_outers
      ,received_outers
      ,expected_unit_price_per_outer
      ,is_order_line_finalized
      ,last_receipt_date
    FROM
      fact_purchase_order_line__source
    ),
  fact_purchase_order_line__cast_type as (
    SELECT 
      CAST(purchase_order_line_key AS INTEGER) as purchase_order_line_key
      ,CAST(description as STRING) as description
      ,CAST(purchase_order_key AS INTEGER) as purchase_order_key
      ,CAST(product_key AS INTEGER) as product_key
      ,CAST(package_type_key AS INTEGER) as package_type_key
      ,CAST(ordered_outers as INTEGER) as ordered_outers
      ,CAST(received_outers as INTEGER) as received_outers
      ,CAST(expected_unit_price_per_outer AS NUMERIC) as expected_unit_price_per_outer
      ,CAST(is_order_line_finalized AS BOOLEAN) as is_order_line_finalized
      ,CAST(last_receipt_date AS DATE) as last_receipt_date
    FROM
      fact_purchase_order_line__rename_column
    ),
  fact_sales_order_line__convert_boolean as (
    SELECT
      purchase_order_line_key
      ,description
      ,purchase_order_key
      ,product_key
      ,package_type_key
      ,ordered_outers
      ,received_outers
      ,expected_unit_price_per_outer
      ,CASE 
        WHEN is_order_line_finalized is true then 'Order line is finalized'
        When is_order_line_finalized is false then 'Order line is not finalized'
        Else 'Error'
      End as is_order_line_finalized
      ,last_receipt_date
    FROM
      fact_purchase_order_line__cast_type
    ),
  fact_purchase_order_line__handle_null as (
    SELECT
      purchase_order_line_key
      ,description
      ,purchase_order_key
      ,product_key
      ,package_type_key
      ,ordered_outers
      ,received_outers
      ,COALESCE(expected_unit_price_per_outer, 0) AS expected_unit_price_per_outer
      ,is_order_line_finalized
      ,last_receipt_date
    FROM
      fact_sales_order_line__convert_boolean
  )

SELECT 
  fact_purchase_line.purchase_order_line_key
  ,fact_purchase_line.description
  ,fact_purchase_line.purchase_order_key
  ,COALESCE(fact_purchase_head.supplier_key, -1) as supplier_key
  ,COALESCE(fact_purchase_head.delivery_method_key, -1) AS delivery_method_key
  ,COALESCE(fact_purchase_head.delivery_method_name, 'Error') as delivery_method_name
  ,COALESCE(fact_purchase_head.contact_person_key, -1) as contact_person_key
  ,fact_purchase_head.order_date
  ,fact_purchase_head.expected_delivery_date
  ,COALESCE(fact_purchase_head.supplier_reference, 'Error') as supplier_reference
  ,fact_purchase_line.product_key
  ,fact_purchase_line.package_type_key
  ,fact_purchase_line.ordered_outers
  ,fact_purchase_line.received_outers
  ,fact_purchase_line.expected_unit_price_per_outer
  ,fact_purchase_line.last_receipt_date
  ,FARM_FINGERPRINT(
    CONCAT(
    fact_purchase_line.is_order_line_finalized
    ,COALESCE(fact_purchase_head.is_order_finalized, 'Error')
    ,package_type_key
    )
    )
    AS purchase_order_line_indicator_key
FROM
  fact_purchase_order_line__handle_null AS fact_purchase_line
LEFT JOIN
  {{ref('stg_fact_purchase_order')}} AS fact_purchase_head
ON
  fact_purchase_line.purchase_order_key = fact_purchase_head.purchase_order_key