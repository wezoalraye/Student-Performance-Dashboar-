{{
    config(
        materialized='table',
        schema='dimensions'
    )
}}

WITH students AS (
    SELECT * FROM {{ ref('stg_students') }}
),

final AS (
    SELECT
        student_id as student_key,
        student_id,
        gender,
        age,
        CASE 
            WHEN age BETWEEN 18 AND 20 THEN 'Young (18-20)'
            WHEN age BETWEEN 21 AND 23 THEN 'Mid (21-23)'
            WHEN age >= 24 THEN 'Senior (24+)'
        END as age_group,
        study_hours_per_week,
        CASE 
            WHEN study_hours_per_week < 10 THEN 'Low (0-9 hrs)'
            WHEN study_hours_per_week BETWEEN 10 AND 20 THEN 'Medium (10-20 hrs)'
            WHEN study_hours_per_week BETWEEN 21 AND 30 THEN 'High (21-30 hrs)'
            ELSE 'Very High (30+ hrs)'
        END as study_intensity,
        transformed_at as effective_date
    FROM students
)

SELECT * FROM final