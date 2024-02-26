SELECT
  person_key AS pickedbyperson_person_key
  ,full_name AS pickedbyperson_full_name
  ,preferred_name AS pickedbyperson_preferred_name
  ,search_name AS pickedbyperson_search_name
  ,is_permitted_to_logon AS pickedbyperson_is_permitted_to_logon
  ,logon_name AS pickedbyperson_logon_name
  ,is_external_logon_provider AS pickedbyperson_is_external_logon_provider
  ,is_system_user AS pickedbyperson_is_system_user
  ,is_employee AS pickedbyperson_is_employee
  ,is_salesperson as pickedbyperson_is_salesperson
FROM
  {{ref('dim_person')}}