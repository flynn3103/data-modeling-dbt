WITH 
  fact_sales_order_lines__source as (
    SELECT
      *
    FROM 
      `vit-lam-data.wide_world_importers.sales__order_lines`
    ),
  fact_sales_order_lines__rename_column as (
    SELECT
      order_line_id as sales_order_line_key
      ,description
      ,order_id as sales_order_key
      ,stock_item_id as product_key
      ,package_type_id as package_type_key
      ,quantity
      ,unit_price
      ,tax_rate
      ,picked_quantity
      ,picking_completed_when
    FROM
      fact_sales_order_lines__source
    ),
  fact_sales_order_lines__cast_type as (
    SELECT 
      CAST(sales_order_line_key AS INTEGER) as sales_order_line_key
      ,CAST(description as STRING) as description
      ,CAST(sales_order_key AS INTEGER) as sales_order_key
      ,CAST(product_key AS INTEGER) as product_key
      ,CAST(package_type_key as INTEGER) as package_type_key
      ,CAST(quantity AS INTEGER) as quantity
      ,CAST(unit_price AS NUMERIC) as unit_price
      ,CAST(tax_rate AS NUMERIC) as tax_rate
      ,CAST(picked_quantity AS INTEGER) as picked_quantity
      ,CAST(picking_completed_when AS DATE) as picking_completed_when
    FROM
      fact_sales_order_lines__rename_column
    ),
  fact_sales_order_line__calculate_measure as (
    SELECT
      *
      ,quantity*unit_price as gross_amount
    FROM
      fact_sales_order_lines__cast_type
    )

SELECT 
  fact_line.sales_order_line_key
  ,fact_line.description
  ,fact_line.sales_order_key
  ,COALESCE(fact_header.customer_key,-1) as customer_key
  ,COALESCE(fact_header.salesperson_person_key,-1) as salesperson_person_key
  ,COALESCE(fact_header.picked_by_person_key,-1) as picked_by_person_key
  ,COALESCE(fact_header.contact_person_key,-1) AS contact_person_key
  ,COALESCE(fact_header.backorder_order_key,-1) AS backorder_order_key
  ,fact_header.expected_delivery_date
  ,order_picking_completed_when
  ,fact_line.product_key
  ,fact_line.quantity
  ,fact_line.unit_price
  ,fact_line.tax_rate
  ,fact_line.picked_quantity
  ,fact_line.picking_completed_when
  ,fact_line.gross_amount
  ,fact_header.order_date
  ,FARM_FINGERPRINT(
    CONCAT(
    fact_header.is_undersupply_backordered
    ,fact_line.package_type_key
    )
    ) AS sales_order_line_indicator_key
FROM
  fact_sales_order_line__calculate_measure AS fact_line
LEFT JOIN 
  {{ ref('stg_fact_sales_order')}} AS fact_header
ON
  fact_line.sales_order_key = fact_header.sales_order_key