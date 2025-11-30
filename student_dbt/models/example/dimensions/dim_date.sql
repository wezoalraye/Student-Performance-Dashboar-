{{
    config(
        materialized='table',
        schema='dimensions'
    )
}}

WITH date_range AS (
    -- Get min and max dates from staging
    SELECT 
        COALESCE(DATE_TRUNC('day', MIN(loaded_at)), '2024-01-01'::DATE) as start_date,
        CURRENT_DATE + INTERVAL '365' DAY as end_date
    FROM {{ source('staging', 'raw_students') }}
),

date_spine AS (
    SELECT 
        start_date + INTERVAL (d) DAY as date_day
    FROM date_range,
    generate_series(0, 730) as t(d)
    WHERE start_date + INTERVAL (d) DAY <= (SELECT end_date FROM date_range)
),

final AS (
    SELECT
        CAST(STRFTIME(date_day, '%Y%m%d') AS INTEGER) as date_key,
        date_day as full_date,
        EXTRACT(YEAR FROM date_day) as year,
        EXTRACT(MONTH FROM date_day) as month,
        EXTRACT(DAY FROM date_day) as day,
        CASE 
            WHEN EXTRACT(MONTH FROM date_day) BETWEEN 9 AND 12 THEN 'Fall'
            WHEN EXTRACT(MONTH FROM date_day) BETWEEN 1 AND 5 THEN 'Spring'
            ELSE 'Summer'
        END as semester,
        CASE 
            WHEN EXTRACT(MONTH FROM date_day) >= 9 
            THEN EXTRACT(YEAR FROM date_day)
            ELSE EXTRACT(YEAR FROM date_day) - 1
        END as academic_year,
        DAYNAME(date_day) as day_name,
        CASE WHEN DAYOFWEEK(date_day) IN (6, 7) THEN TRUE ELSE FALSE END as is_weekend
    FROM date_spine
)

SELECT * FROM final
ORDER BY date_key