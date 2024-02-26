SELECT
  person_key AS salesperson_person_key
  ,full_name AS salesperson_full_name
  ,preferred_name AS salesperson_preferred_name
  ,search_name AS salesperson_search_name
  ,is_permitted_to_logon AS salesperson_is_permitted_to_logon
  ,logon_name AS salesperson_logon_name
  ,is_external_logon_provider AS salesperson_is_external_logon_provider
  ,is_system_user AS salesperson_is_system_user
  ,is_employee AS salesperson_is_employee
FROM
  {{ref('dim_person')}}
WHERE
  is_salesperson IN ('Sales Person','Undefined','Error')