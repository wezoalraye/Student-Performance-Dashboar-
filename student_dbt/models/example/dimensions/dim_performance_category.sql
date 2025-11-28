{{
    config(
        materialized='table',
        schema='dimensions'
    )
}}

WITH performance_levels AS (
    SELECT 'HIGH' as category_code, 'High Performance' as category_name, 3.5 as min_gpa, 4.0 as max_gpa, 1 as sort_order
    UNION ALL
    SELECT 'MEDIUM', 'Medium Performance', 2.0, 3.49, 2
    UNION ALL
    SELECT 'LOW', 'Low Performance', 0.0, 1.99, 3
),

final AS (
    SELECT
        ROW_NUMBER() OVER (ORDER BY sort_order) as performance_key,
        category_code,
        category_name,
        min_gpa,
        max_gpa,
        CASE 
            WHEN category_code = 'HIGH' THEN 'Exceeds Expectations'
            WHEN category_code = 'MEDIUM' THEN 'Meets Expectations'
            WHEN category_code = 'LOW' THEN 'Needs Improvement'
        END as status_description,
        CASE WHEN category_code = 'LOW' THEN TRUE ELSE FALSE END as is_at_risk,
        sort_order
    FROM performance_levels
)

SELECT * FROM final
ORDER BY sort_order
