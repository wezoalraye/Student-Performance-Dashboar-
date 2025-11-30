
    
    

select
    student_key as unique_field,
    count(*) as n_records

from "student_performance"."analytics_dimensions"."dim_student"
where student_key is not null
group by student_key
having count(*) > 1


