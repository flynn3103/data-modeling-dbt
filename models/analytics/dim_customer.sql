WITH
  dim_customer__source AS (
    SELECT
      *
    FROM
      `vit-lam-data.wide_world_importers.sales__customers`
    ),
  dim_customer__rename_column AS (
    SELECT
      customer_id as customer_key
      ,customer_name
      ,credit_limit
      ,account_opened_date
      ,standard_discount_percentage
      ,is_statement_sent
      ,is_on_credit_hold
      ,payment_days
      ,delivery_run
      ,run_position
      ,delivery_postal_code
      ,postal_postal_code
      ,customer_category_id as customer_category_key
      ,buying_group_id as buying_group_key
      ,delivery_method_id as delivery_method_key
      ,delivery_city_id as delivery_city_key
      ,postal_city_id as postal_city_key
      ,primary_contact_person_id as primary_contact_person_key
      ,alternate_contact_person_id as alternate_contact_person_key
      ,bill_to_customer_id as bill_to_customer_key
    FROM 
      dim_customer__source
    ),
  dim_customer__cast_type AS (
    SELECT
      CAST(customer_key AS INTEGER) as customer_key
      ,CAST(customer_name AS STRING) as customer_name
      ,CAST(credit_limit as NUMERIC) as credit_limit
      ,CAST(account_opened_date AS DATE) AS account_opened_date
      ,CAST(standard_discount_percentage AS NUMERIC) AS standard_discount_percentage
      ,CAST(is_statement_sent AS BOOLEAN) AS is_statement_sent
      ,CAST(is_on_credit_hold as BOOLEAN) as is_on_credit_hold
      ,CAST(payment_days AS INTEGER) AS payment_days
      ,CAST(delivery_run AS STRING) AS delivery_run
      ,CAST(run_position AS STRING) AS run_position
      ,CAST(delivery_postal_code AS STRING) AS delivery_postal_code
      ,CAST(postal_postal_code AS STRING) AS postal_postal_code
      ,CAST(customer_category_key as INTEGER) as customer_category_key
      ,CAST(buying_group_key as INTEGER) as buying_group_key
      ,CAST(delivery_method_key as INTEGER) as delivery_method_key
      ,CAST(delivery_city_key as INTEGER) as delivery_city_key
      ,CAST(postal_city_key as INTEGER) as postal_city_key
      ,CAST(primary_contact_person_key as INTEGER) as primary_contact_person_key
      ,CAST(alternate_contact_person_key as INTEGER) as alternate_contact_person_key
      ,CAST(bill_to_customer_key as INTEGER) as bill_to_customer_key
    FROM
      dim_customer__rename_column
    ),
  dim_customer__convert_boolean AS (
    SELECT
      customer_key
      ,customer_name
      ,credit_limit
      ,account_opened_date
      ,standard_discount_percentage
      ,CASE
        WHEN is_statement_sent is true then 'Statement Sent'
        WHEN is_statement_sent is false then 'Not Statement Sent'
      END AS is_statement_sent
      ,CASE
        WHEN is_on_credit_hold is true then 'On Credit Hold'
        WHEN is_on_credit_hold is false then 'Not On Credit Hold'
      END AS is_on_credit_hold
      ,payment_days
      ,delivery_run
      ,run_position
      ,delivery_postal_code
      ,postal_postal_code
      ,customer_category_key
      ,buying_group_key
      ,delivery_method_key
      ,delivery_city_key
      ,postal_city_key
      ,primary_contact_person_key
      ,alternate_contact_person_key
      ,bill_to_customer_key
    FROM
      dim_customer__cast_type
    ),
  dim_customer__add_undefined_record AS (
    SELECT
      *
    FROM dim_customer__convert_boolean
    UNION ALL
    SELECT
      0 as customer_key
      ,'Undefined' as customer_name
      ,0 as credit_limit
      ,null as account_opened_date
      ,0 as standard_discount_percentage
      ,'Undefined' as is_statement_sent
      ,'Undefined' as is_on_credit_hold
      ,0 as payment_days
      ,'Undefined' as delivery_run
      ,'Undefined' as run_position
      ,'Undefined' as delivery_postal_code
      ,'Undefined' as postal_postal_code
      ,0 as customer_category_key
      ,0 as buying_group_key
      ,0 as elivery_method_key
      ,0 as delivery_city_key
      ,0 as postal_city_key
      ,0 as primary_contact_person_key
      ,0 as alternate_contact_person_key
      ,0 as bill_to_customer_key
  )

SELECT
      dim_customer.customer_key
      ,dim_customer.customer_name
      ,COALESCE(dim_customer.credit_limit,0) as credit_limit
      ,dim_customer.account_opened_date
      ,dim_customer.standard_discount_percentage
      ,dim_customer.is_statement_sent
      ,dim_customer.is_on_credit_hold
      ,dim_customer.payment_days
      ,COALESCE(dim_customer.delivery_run,'Undefined') as delivery_run
      ,COALESCE(dim_customer.run_position,'Undefined') as run_position
      ,dim_customer.delivery_postal_code
      ,dim_customer.postal_postal_code
      ,dim_customer.customer_category_key
      ,COALESCE(dim_customer_category.customer_category_name,'Error') as customer_category_name
      ,COALESCE(dim_customer.buying_group_key,0) as buying_group_key
      ,COALESCE(dim_buying_group.buying_group_name,'Error') as buying_group_name
      ,dim_customer.delivery_method_key
      ,COALESCE(dim_delivery_method.delivery_method_name,'Error') as delivery_method_name
      ,dim_customer.delivery_city_key
      ,COALESCE(dim_delivery_city.city_name,'Error') as delivery_city_name
      ,COALESCE(dim_delivery_city.state_province_key,0) as delivery_state_province_key
      ,COALESCE(dim_delivery_city.state_province_code,'Error') as delivery_city_state_province_code
      ,COALESCE(dim_delivery_city.sales_territory,'Error') as delivery_city_sales_territory
      ,dim_customer.postal_city_key
      ,COALESCE(dim_postal_city.city_name,'Error') as postal_city_name
      ,COALESCE(dim_postal_city.state_province_key,0) as postal_city_state_province_key
      ,COALESCE(dim_postal_city.state_province_code,'Error') as postal_city_state_province_code
      ,COALESCE(dim_postal_city.sales_territory,'Error') as postal_city_sales_territory
      ,COALESCE(dim_customer.alternate_contact_person_key,0) as alternate_contact_person_key
      ,dim_customer.primary_contact_person_key
      ,bill_to_customer_key
FROM
  dim_customer__add_undefined_record as dim_customer
LEFT JOIN 
  {{ref('stg_dim_customer_category')}} as dim_customer_category
ON dim_customer.customer_category_key = dim_customer_category.customer_category_key
LEFT JOIN
  {{ref('stg_dim_buying_group')}} as dim_buying_group
ON dim_customer.buying_group_key = dim_buying_group.buying_group_key
LEFT JOIN
  {{ref('stg_dim_delivery_method')}} as dim_delivery_method
ON dim_customer.delivery_method_key = dim_delivery_method.delivery_method_key
LEFT JOIN
  {{ref('stg_dim_city')}} as dim_delivery_city
ON dim_customer.delivery_city_key = dim_delivery_city.city_key
LEFT JOIN
  {{ref('stg_dim_city')}} as dim_postal_city
ON dim_customer.postal_city_key = dim_postal_city.city_key