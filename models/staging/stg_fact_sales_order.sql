WITH 
  fact_sales_order__source as (
    SELECT
      *
    FROM 
      `vit-lam-data.wide_world_importers.sales__orders`
    ),
  fact_sales_order__rename_column as (
    SELECT
      order_id as sales_order_key
      , customer_id as customer_key
      , salesperson_person_id as salesperson_person_key
      , picked_by_person_id as picked_by_person_key
      , contact_person_id as contact_person_key
      , backorder_order_id as backorder_order_key
      , order_date
      , expected_delivery_date
      , customer_purchase_order_number
      , is_undersupply_backordered
      , picking_completed_when as order_picking_completed_when
    FROM
      fact_sales_order__source
    ),
  fact_sales_order__cast_type as (
    SELECT
      CAST(sales_order_key as INTEGER) as sales_order_key
      ,CAST(customer_key as INTEGER) as customer_key
      ,CAST(salesperson_person_key as INTEGER) as salesperson_person_key
      ,CAST(picked_by_person_key as INTEGER) as picked_by_person_key
      ,CAST(contact_person_key as INTEGER) as contact_person_key
      ,CAST(backorder_order_key as INTEGER) as backorder_order_key
      ,CAST(order_date as Date) as order_date
      ,CAST(expected_delivery_date as Date) as expected_delivery_date
      ,CAST(customer_purchase_order_number as Numeric) as customer_purchase_order_number
      ,CAST(is_undersupply_backordered as BOOLEAN) as is_undersupply_backordered
      ,CAST(order_picking_completed_when as Date) as order_picking_completed_when
    FROM
      fact_sales_order__rename_column
    ),
  fact_sales_order__convert_boolean as (
    SELECT
        sales_order_key
      , customer_key
      , salesperson_person_key
      , picked_by_person_key
      , contact_person_key
      , backorder_order_key
      , order_date
      , expected_delivery_date
      , customer_purchase_order_number
      , order_picking_completed_when
      ,CASE 
      WHEN is_undersupply_backordered is true THEN 'Under Supply Back Ordered'
      WHEN is_undersupply_backordered is false THEN 'Not Under Supply Back Ordered'
      END AS is_undersupply_backordered
    FROM 
      fact_sales_order__cast_type
  ),
  fact_sales_order__handle_null as (
    SELECT
      sales_order_key
      , customer_key
      , salesperson_person_key
      , contact_person_key
      , order_date
      , expected_delivery_date
      , is_undersupply_backordered
      , order_picking_completed_when
      ,COALESCE(picked_by_person_key,0) as picked_by_person_key
      ,COALESCE(backorder_order_key,0) as backorder_order_key
      ,COALESCE(customer_purchase_order_number,0) as customer_purchase_order_number
    FROM
      fact_sales_order__convert_boolean
  )

SELECT
  sales_order_key
  , customer_key
  , salesperson_person_key
  , picked_by_person_key
  , contact_person_key
  , backorder_order_key
  , order_date
  , expected_delivery_date
  , customer_purchase_order_number
  , is_undersupply_backordered
  , order_picking_completed_when
FROM
  fact_sales_order__handle_null