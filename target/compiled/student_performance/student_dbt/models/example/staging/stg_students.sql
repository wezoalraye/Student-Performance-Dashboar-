

WITH source AS (
    SELECT * FROM "student_performance"."staging"."raw_students"
),

cleaned AS (
    SELECT
        student_id,
        UPPER(TRIM(gender)) as gender,
        age,
        study_hours_per_week,
        ROUND(attendance_rate, 2) as attendance_rate,
        ROUND(gpa, 2) as gpa,
        TRIM(major) as major,
        UPPER(TRIM(performance_category)) as performance_category,
        loaded_at,
        CURRENT_TIMESTAMP as transformed_at
    FROM source
)

SELECT * FROM cleaned