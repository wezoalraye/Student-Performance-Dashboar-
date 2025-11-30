
    
    

select
    performance_key as unique_field,
    count(*) as n_records

from "student_performance"."analytics_dimensions"."dim_performance_category"
where performance_key is not null
group by performance_key
having count(*) > 1


