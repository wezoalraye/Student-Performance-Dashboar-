
  
    
    

    create  table
      "student_performance"."analytics_dimensions"."dim_date__dbt_tmp"
  
    as (
      

WITH date_spine AS (
    SELECT DATE '2024-01-01' + INTERVAL (d) DAY as date_day
    FROM generate_series(0, 365) as t(d)
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
  
  