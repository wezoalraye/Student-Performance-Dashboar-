
  
    
    

    create  table
      "student_performance"."analytics_dimensions"."dim_date__dbt_tmp"
  
    as (
      

WITH bounds AS (
    SELECT COALESCE(MIN(CAST(loaded_at AS DATE)), DATE '2024-01-01') as start_date
    FROM staging.raw_students
),
date_spine AS (
    SELECT bounds.start_date + INTERVAL (d) DAY as date_day
    FROM bounds, generate_series(0, date_diff('day', bounds.start_date, CURRENT_DATE)) as t(d)
),

final AS (
    SELECT
        CAST(STRFTIME(date_day, '%Y%m%d') AS INTEGER) as date_key,
        date_day as full_date,
        EXTRACT(YEAR FROM date_day) as year,
        EXTRACT(MONTH FROM date_day) as month,
        CASE 
            WHEN EXTRACT(MONTH FROM date_day) BETWEEN 9 AND 12 THEN 'Fall'
            WHEN EXTRACT(MONTH FROM date_day) BETWEEN 1 AND 5 THEN 'Spring'
            ELSE 'Summer'
        END as semester,
        CASE 
            WHEN EXTRACT(MONTH FROM date_day) >= 9 
            THEN EXTRACT(YEAR FROM date_day)
            ELSE EXTRACT(YEAR FROM date_day) - 1
        END as academic_year
    FROM date_spine
)

SELECT * FROM final
    );
  
  