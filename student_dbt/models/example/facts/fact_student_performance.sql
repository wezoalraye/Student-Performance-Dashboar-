{{
    config(
        materialized='table',
        schema='facts'
    )
}}

WITH students AS (
    SELECT * FROM {{ ref('stg_students') }}
),

dim_student AS (
    SELECT * FROM {{ ref('dim_student') }}
),

dim_major AS (
    SELECT * FROM {{ ref('dim_major') }}
),

dim_performance AS (
    SELECT * FROM {{ ref('dim_performance_category') }}
),

dim_date AS (
    SELECT * FROM {{ ref('dim_date') }}
    WHERE full_date = CURRENT_DATE
),

fact_table AS (
    SELECT
        ROW_NUMBER() OVER (ORDER BY s.student_id) as performance_id,
        ds.student_key,
        dm.major_key,
        dp.performance_key,
        dd.date_key as snapshot_date_key,
        s.student_id,
        s.gpa as gpa_score,
        s.attendance_rate,
        s.study_hours_per_week,
        ROUND(
            (s.gpa * 0.5) + 
            (s.attendance_rate / 100 * 4 * 0.3) +
            (LEAST(s.study_hours_per_week / 40 * 4, 4) * 0.2),
            2
        ) as composite_performance_score,
        CASE 
            WHEN s.attendance_rate >= 80 THEN 'High Attendance'
            WHEN s.attendance_rate >= 50 THEN 'Medium Attendance'
            ELSE 'Low Attendance'
        END as attendance_category,
        CASE WHEN s.gpa < 2.0 THEN 1 ELSE 0 END as is_academic_risk,
        CASE WHEN s.attendance_rate < 60 THEN 1 ELSE 0 END as is_attendance_risk,
        CASE WHEN s.gpa < 2.0 OR s.attendance_rate < 60 THEN 1 ELSE 0 END as is_at_risk,
        CASE WHEN s.gpa >= 3.5 AND s.attendance_rate >= 85 THEN 1 ELSE 0 END as is_high_achiever,
        CURRENT_TIMESTAMP as created_at
    FROM students s
    INNER JOIN dim_student ds ON s.student_id = ds.student_id
    INNER JOIN dim_major dm ON s.major = dm.major_code
    INNER JOIN dim_performance dp ON s.performance_category = dp.category_code
    CROSS JOIN dim_date dd
)

SELECT * FROM fact_table