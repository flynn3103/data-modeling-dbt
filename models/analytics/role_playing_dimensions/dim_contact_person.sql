SELECT
  person_key AS contact_person_key
  ,full_name AS contact_person_full_name
  ,preferred_name AS contact_person_preferred_name
  ,search_name AS contact_person_search_name
  ,is_permitted_to_logon AS contact_person_is_permitted_to_logon
  ,logon_name AS contact_person_logon_name
  ,is_external_logon_provider AS contact_person_is_external_logon_provider
  ,is_system_user AS contact_person_is_system_user
  ,is_employee AS contact_person_is_employee
  ,is_salesperson as contact_person_is_salesperson
FROM
  {{ref('dim_person')}}