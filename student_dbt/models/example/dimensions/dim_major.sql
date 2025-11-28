{{
    config(
        materialized='table',
        schema='dimensions'
    )
}}

WITH distinct_majors AS (
    SELECT DISTINCT major FROM {{ ref('stg_students') }}
),

final AS (
    SELECT
        ABS(HASH(major)) as major_key,
        major as major_code,
        major as major_name,
        CASE 
            WHEN major IN ('Arts') THEN 'Humanities'
            WHEN major IN ('Business') THEN 'Business & Economics'
            WHEN major IN ('Engineering', 'Science') THEN 'STEM'
            WHEN major IN ('Education') THEN 'Social Sciences'
            ELSE 'Other'
        END as department,
        CASE 
            WHEN major IN ('Engineering', 'Science') THEN 'Technical'
            WHEN major IN ('Arts', 'Education') THEN 'Liberal Arts'
            WHEN major IN ('Business') THEN 'Professional'
            ELSE 'General'
        END as field_type,
        CURRENT_TIMESTAMP as created_at
    FROM distinct_majors
)

SELECT * FROM final
ORDER BY major_name