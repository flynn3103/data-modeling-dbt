WITH dim_person__source as 
(
  SELECT 
  *
  FROM 
  `vit-lam-data.wide_world_importers.application__people`
),
  dim_person__rename AS 
(
  SELECT
    person_id AS person_key
    ,full_name
    ,preferred_name
    ,search_name
    ,is_permitted_to_logon
    ,logon_name
    ,is_external_logon_provider
    ,is_system_user
    ,is_employee
    ,is_salesperson
  FROM
  dim_person__source
),
  dim_person__cast AS
(
  SELECT
    CAST(person_key AS INTEGER) as person_key
    ,CAST(full_name AS STRING) as full_name
    ,CAST(preferred_name AS STRING) as preferred_name
    ,CAST(search_name AS STRING) as search_name
    ,CAST(is_permitted_to_logon AS BOOLEAN) as is_permitted_to_logon
    ,CAST(logon_name AS STRING) as logon_name
    ,CAST(is_external_logon_provider AS BOOLEAN) as is_external_logon_provider
    ,CAST(is_system_user AS BOOLEAN) as is_system_user
    ,CAST(is_employee AS BOOLEAN) as is_employee
    ,CAST(is_salesperson AS BOOLEAN) as is_salesperson
  FROM
  dim_person__rename
),
  dim_person__convert_boolean AS
(
  SELECT
    person_key
    ,full_name
    ,preferred_name
    ,search_name
    ,CASE
        WHEN is_permitted_to_logon is true then 'Permitted to logon'
        WHEN is_permitted_to_logon is false then 'Not Permitted to logon'
      END AS is_permitted_to_logon
    ,logon_name
    ,CASE
        WHEN is_external_logon_provider is true then 'External logon provider'
        WHEN is_external_logon_provider is false then 'Not External logon provider'
      END AS is_external_logon_provider
    ,CASE
        WHEN is_system_user is true then 'System User'
        WHEN is_system_user is false then 'Not System User'
      END AS is_system_user
    ,CASE
        WHEN is_employee is true then 'Employee'
        WHEN is_employee is false then 'Not Employee'
      END AS is_employee
    ,CASE
        WHEN is_salesperson is true then 'Sales Person'
        WHEN is_salesperson is false then 'Not Sales Person'
      END AS is_salesperson
  FROM
    dim_person__cast
),
  dim_person__add_undefined_record AS
(
  SELECT 
  person_key
  ,full_name
  ,preferred_name
  ,search_name
  ,is_permitted_to_logon
  ,logon_name
  ,is_external_logon_provider
  ,is_system_user
  ,is_employee
  ,is_salesperson
  FROM dim_person__convert_boolean
  UNION ALL
  SELECT
  0 as person_key
  ,'Undefined' as full_name
  ,'Undefined' as preferred_name
  ,'Undefined' as search_name
  ,'Undefined' as is_permitted_to_logon
  ,'Undefined' as logon_name
  ,'Undefined' as is_external_logon_provider
  ,'Undefined' as is_system_user
  ,'Undefined' as is_employee
  ,'Undefined' as is_salesperson
)

SELECT
  person_key
  ,full_name
  ,preferred_name
  ,search_name
  ,is_permitted_to_logon
  ,logon_name
  ,is_external_logon_provider
  ,is_system_user
  ,is_employee
  ,is_salesperson
FROM
  dim_person__add_undefined_record