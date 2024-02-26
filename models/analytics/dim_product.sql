WITH dim_product__source as (
  SELECT 
    *
    FROM `vit-lam-data.wide_world_importers.warehouse__stock_items`
  ),
  dim_product__rename_column as (
  SELECT
    stock_item_id as product_key
    ,stock_item_name as product_name
    ,brand as brand_name
    ,size
    ,lead_time_days
    ,quantity_per_outer
    ,is_chiller_stock
    ,barcode
    ,tax_rate
    ,unit_price
    ,recommended_retail_price
    ,typical_weight_per_unit
    ,tags
    ,search_details
    ,unit_package_id as unit_package_key
    ,outer_package_id as outer_package_key
    ,color_id as color_key
    ,supplier_id as supplier_key
    FROM dim_product__source
  ),
  dim_product__cast_type AS (
  SELECT
    CAST(product_key AS INTEGER) AS product_key
    ,CAST(product_name AS STRING) AS product_name
    ,CAST(brand_name AS STRING) AS brand_name
    ,CAST(size AS STRING) AS size
    ,CAST(lead_time_days AS INTEGER) AS lead_time_days
    ,CAST(quantity_per_outer AS INTEGER) AS quantity_per_outer
    ,CAST(is_chiller_stock AS BOOLEAN) AS is_chiller_stock
    ,CAST(barcode AS STRING) AS barcode
    ,CAST(tax_rate AS NUMERIC) AS tax_rate
    ,CAST(unit_price AS NUMERIC) AS unit_price
    ,CAST(recommended_retail_price AS NUMERIC) AS recommended_retail_price
    ,CAST(typical_weight_per_unit AS NUMERIC) AS typical_weight_per_unit
    ,CAST(tags AS STRING) AS tags
    ,CAST(search_details AS STRING) AS search_details
    ,CAST(unit_package_key AS INTEGER) AS unit_package_key
    ,CAST(outer_package_key AS INTEGER) AS outer_package_key
    ,CAST(color_key AS INTEGER) AS color_key
    ,CAST(supplier_key AS INTEGER) AS supplier_key
  FROM dim_product__rename_column
  ),
  dim_product__convert_boolean as (
  SELECT
    product_key
    ,product_name
    ,brand_name
    ,size
    ,lead_time_days
    ,quantity_per_outer
    ,CASE 
    WHEN is_chiller_stock is true THEN 'Chiller Stock'
    WHEN is_chiller_stock is false THEN 'Not Chiller Stock'
    END AS is_chiller_stock
    ,barcode
    ,tax_rate
    ,unit_price
    ,recommended_retail_price
    ,typical_weight_per_unit
    ,tags
    ,search_details
    ,unit_package_key
    ,outer_package_key
    ,color_key
    ,supplier_key
  FROM dim_product__cast_type
  ),
  dim_product__handle_null as (
    SELECT
      product_key
      ,product_name
      ,COALESCE(brand_name,'Undefined') as brand_name
      ,COALESCE(size,'Undefined') as size
      ,lead_time_days
      ,quantity_per_outer
      ,is_chiller_stock
      ,COALESCE(barcode,'Undefined') as barcode
      ,tax_rate
      ,unit_price
      ,COALESCE(recommended_retail_price,0) as recommended_retail_price
      ,typical_weight_per_unit
      ,COALESCE(tags,'Undefined') as tags
      ,search_details
      ,unit_package_key
      ,outer_package_key
      ,color_key
      ,supplier_key
    FROM dim_product__convert_boolean
  ),
  dim_product__add_undefined_record as (
    SELECT
      product_key
    ,product_name
    ,brand_name
    ,size
    ,lead_time_days
    ,quantity_per_outer
    ,is_chiller_stock
    ,barcode
    ,tax_rate
    ,unit_price
    ,recommended_retail_price
    ,typical_weight_per_unit
    ,tags
    ,search_details
    ,unit_package_key
    ,outer_package_key
    ,color_key
    ,supplier_key
    FROM
      dim_product__handle_null
    UNION ALL
    SELECT
      0 as product_key
      ,'Undefined' as product_name
      ,'Undefined' as brand_name
      ,'Undefined' as size
      ,0 as lead_time_days
      ,0 as quantity_per_outer
      ,'Undefined' as is_chiller_stock
      ,'Undefined' as barcode
      ,0 as tax_rate
      ,0 as unit_price
      ,0 as recommended_retail_price
      ,0 as typical_weight_per_unit
      ,'Undefined' as tags
      ,'Undefined' as search_details
      ,0 as unit_package_key
      ,0 as outer_package_key
      ,0 as color_key
      ,0 as supplier_key
  )

SELECT 
  dim_product.product_key
  ,dim_product.product_name
  ,dim_product.brand_name
  ,dim_product.size
  ,dim_product.lead_time_days
  ,dim_product.quantity_per_outer
  ,dim_product.is_chiller_stock
  ,dim_product.barcode
  ,dim_product.tax_rate
  ,dim_product.unit_price
  ,dim_product.recommended_retail_price
  ,dim_product.typical_weight_per_unit
  ,dim_product.tags
  ,dim_product.search_details
  ,dim_product.unit_package_key
  ,COALESCE(dim_unit_package.package_type_name,'Error') as unit_package_type_name
  ,dim_product.outer_package_key
  ,COALESCE(dim_outer_package.package_type_name,'Error') as outer_package_type_name
  ,COALESCE(dim_product.color_key,0) as color_key
  ,COALESCE(dim_color.color_name,'Error') as color_name
  ,dim_product.supplier_key
  ,COALESCE(dim_supplier.supplier_name,'Error') as supplier_name
  ,COALESCE(dim_supplier.supplier_reference,'Error') as supplier_reference
  ,COALESCE(dim_supplier.bank_account_name,'Error') as bank_account_name
  ,COALESCE(dim_supplier.bank_account_branch,'Error') as bank_account_branch
  ,COALESCE(dim_supplier.bank_account_code,'Error') as bank_account_code
  ,COALESCE(dim_supplier.bank_account_number,'Error') as bank_account_number
  ,COALESCE(dim_supplier.bank_international_code,'Error') as bank_international_code
  ,COALESCE(dim_supplier.payment_days,-1) as payment_days
  ,COALESCE(dim_supplier.delivery_postal_code,'Error') as delivery_postal_code
  ,COALESCE(dim_supplier.postal_postal_code,'Error') as postal_postal_code
  ,COALESCE(dim_supplier.supplier_category_key,-1) as supplier_category_key
  ,COALESCE(dim_supplier.supplier_category_name,'Error') as supplier_category_name
  ,COALESCE(dim_supplier.primary_contact_person_key,-1) as primary_contact_person_key
  ,COALESCE(dim_supplier.alternate_contact_person_key,-1) as alternate_contact_person_key
  ,COALESCE(dim_supplier.delivery_method_key,-1) as delivery_method_key
  ,COALESCE(dim_delivery_method.delivery_method_name,'Error') as delivery_method_name
  ,COALESCE(dim_supplier.delivery_city_key,-1) as delivery_city_key
  ,COALESCE(dim_supplier.delivery_city_name,'Error') as delivery_city_name
  ,COALESCE(dim_supplier.delivery_state_province_key,-1) as delivery_state_province_key
  ,COALESCE(dim_supplier.delivery_city_state_province_code,'Error') as delivery_city_state_province_code
  ,COALESCE(dim_supplier.delivery_city_sales_territory,'Error') as delivery_city_sales_territory
  ,COALESCE(dim_supplier.postal_city_key,-1) as postal_city_key
  ,COALESCE(dim_supplier.postal_city_name,'Error') as postal_city_name
  ,COALESCE(dim_supplier.postal_city_state_province_key,-1) as postal_city_state_province_key
  ,COALESCE(dim_supplier.postal_city_state_province_code,'Error') as postal_city_state_province_code
  ,COALESCE(dim_supplier.postal_city_sales_territory,'Error') as postal_city_sales_territory
  ,COALESCE(dim_external_stock_item.category_key,-1) as category_key
  ,COALESCE(dim_external_stock_item.category_name,'Error') as category_name
  ,COALESCE(dim_external_stock_item.parent_category_key,-1) as parent_category_key
  ,COALESCE(dim_external_stock_item.category_level,-1) as category_level
FROM dim_product__add_undefined_record as dim_product
LEFT JOIN {{ref('dim_supplier')}} as dim_supplier
ON dim_supplier.supplier_key = dim_product.supplier_key
LEFT JOIN {{ref('stg_dim_color')}} as dim_color
ON dim_product.color_key = dim_color.color_key
LEFT JOIN {{ref('dim_package_type')}} as dim_unit_package
ON dim_product.unit_package_key = dim_unit_package.package_type_key
LEFT JOIN {{ref('dim_package_type')}} as dim_outer_package
ON dim_product.outer_package_key = dim_outer_package.package_type_key
LEFT JOIN {{ref('stg_dim_delivery_method')}} as dim_delivery_method
ON dim_supplier.delivery_method_key = dim_delivery_method.delivery_method_key
LEFT JOIN {{ref('dim_external_stock_item')}} as dim_external_stock_item
ON dim_product.product_key = dim_external_stock_item.stock_item_key