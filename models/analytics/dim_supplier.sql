WITH dim_supplier__source as 
(
  SELECT 
  *
  FROM 
  `vit-lam-data.wide_world_importers.purchasing__suppliers`
),
  dim_supplier__rename_column AS (
    SELECT
      supplier_id as supplier_key
      ,supplier_name
      ,supplier_reference
      ,bank_account_name
      ,bank_account_branch
      ,bank_account_code
      ,bank_account_number
      ,bank_international_code
      ,payment_days
      ,delivery_postal_code
      ,postal_postal_code
      ,supplier_category_id as supplier_category_key
      ,primary_contact_person_id as primary_contact_person_key
      ,alternate_contact_person_id as alternate_contact_person_key
      ,delivery_method_id as delivery_method_key
      ,delivery_city_id as delivery_city_key
      ,postal_city_id as postal_city_key
    FROM 
      dim_supplier__source
    ),
  dim_supplier__cast_type AS (
    SELECT
      CAST(supplier_key AS INTEGER) as supplier_key
      ,CAST(supplier_name AS STRING) as supplier_name
      ,CAST(supplier_reference AS STRING) AS supplier_reference
      ,CAST(bank_account_name AS STRING) AS bank_account_name
      ,CAST(bank_account_branch AS STRING) AS bank_account_branch
      ,CAST(bank_account_code AS STRING) AS bank_account_code
      ,CAST(bank_account_number AS STRING) AS bank_account_number
      ,CAST(bank_international_code AS STRING) AS bank_international_code
      ,CAST(payment_days AS INTEGER) AS payment_days
      ,CAST(delivery_postal_code AS STRING) AS delivery_postal_code
      ,CAST(postal_postal_code AS STRING) AS postal_postal_code
      ,CAST(supplier_category_key as INTEGER) as supplier_category_key
      ,CAST(primary_contact_person_key as INTEGER) as primary_contact_person_key
      ,CAST(alternate_contact_person_key as INTEGER) as alternate_contact_person_key
      ,CAST(delivery_method_key as INTEGER) as delivery_method_key
      ,CAST(delivery_city_key as INTEGER) as delivery_city_key
      ,CAST(postal_city_key as INTEGER) as postal_city_key
    FROM
      dim_supplier__rename_column
    ),
  dim_supplier__add_undefined_record AS (
    SELECT
      *
    FROM dim_supplier__cast_type
    UNION ALL
    SELECT
      0 as supplier_key
      ,'Undefined' as supplier_name
      ,'Undefined' as supplier_reference
      ,'Undefined' as bank_account_name
      ,'Undefined' as bank_account_branch
      ,'Undefined' as bank_account_code
      ,'Undefined' as bank_account_number
      ,'Undefined' as bank_international_code
      ,0 as payment_days
      ,'Undefined' as delivery_postal_code
      ,'Undefined' as postal_postal_code
      ,0 as supplier_category_key
      ,0 as primary_contact_person_key
      ,0 as alternate_contact_person_key
      ,0 as elivery_method_key
      ,0 as delivery_city_key
      ,0 as postal_city_key
  )

SELECT
      dim_supplier.supplier_key
      ,dim_supplier.supplier_name
      ,dim_supplier.supplier_reference
      ,dim_supplier.bank_account_name
      ,dim_supplier.bank_account_branch
      ,dim_supplier.bank_account_code
      ,dim_supplier.bank_account_number
      ,dim_supplier.bank_international_code
      ,dim_supplier.payment_days
      ,dim_supplier.delivery_postal_code
      ,dim_supplier.postal_postal_code
      ,dim_supplier.supplier_category_key
      ,COALESCE(dim_supplier_category.supplier_category_name,'Error') as supplier_category_name
      ,dim_supplier.primary_contact_person_key
      ,dim_supplier.alternate_contact_person_key
      ,COALESCE(dim_supplier.delivery_method_key,0) as delivery_method_key
      ,COALESCE(dim_delivery_method.delivery_method_name,'Error') as delivery_method_name
      ,dim_supplier.delivery_city_key
      ,COALESCE(dim_delivery_city.city_name,'Error') as delivery_city_name
      ,COALESCE(dim_delivery_city.state_province_key,0) as delivery_state_province_key
      ,COALESCE(dim_delivery_city.state_province_code,'Error') as delivery_city_state_province_code
      ,COALESCE(dim_delivery_city.sales_territory,'Error') as delivery_city_sales_territory
      ,dim_supplier.postal_city_key
      ,COALESCE(dim_postal_city.city_name,'Error') as postal_city_name
      ,COALESCE(dim_postal_city.state_province_key,0) as postal_city_state_province_key
      ,COALESCE(dim_postal_city.state_province_code,'Error') as postal_city_state_province_code
      ,COALESCE(dim_postal_city.sales_territory,'Error') as postal_city_sales_territory
FROM
  dim_supplier__add_undefined_record as dim_supplier
LEFT JOIN 
  {{ref('stg_dim_supplier_category')}} as dim_supplier_category
ON dim_supplier.supplier_category_key = dim_supplier_category.supplier_category_key
LEFT JOIN
  {{ref('stg_dim_delivery_method')}} as dim_delivery_method
ON dim_supplier.delivery_method_key = dim_delivery_method.delivery_method_key
LEFT JOIN
  {{ref('stg_dim_city')}} as dim_delivery_city
ON dim_supplier.delivery_city_key = dim_delivery_city.city_key
LEFT JOIN
  {{ref('stg_dim_city')}} as dim_postal_city
ON dim_supplier.postal_city_key = dim_postal_city.city_key