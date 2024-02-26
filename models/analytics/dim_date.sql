with dim_date_generate as (
    SELECT
      *
    FROM
      UNNEST(GENERATE_DATE_ARRAY('2010-01-01', '2030-01-01', INTERVAL 1 DAY)) AS date 
)
, dim_date__enrich as (
  SELECT
  *
  , FORMAT_DATE('%A', date) AS day_of_week
  , FORMAT_DATE('%a', date) AS day_of_week_short
  , DATE_TRUNC(date, month) as year_month
  , FORMAT_DATE('%B', date) as month
  , DATE_TRUNC(date, year) as year
  , EXTRACT(YEAR FROM date) AS year_number
  from dim_date_generate
)
, dim_date_weekend as (
  select
  *
  , CASE 
    WHEN day_of_week_short IN ('Mon', 'Tue', 'Wed', 'Thu', 'Fri') THEN 'Weekday' 
    WHEN day_of_week_short in ('Sat', 'Sun') THEN 'Weekend'
    ELSE 'Invalid' END
    AS is_weekday_or_weekend
  from dim_date__enrich
)
select * from dim_date_weekend as dim_date
