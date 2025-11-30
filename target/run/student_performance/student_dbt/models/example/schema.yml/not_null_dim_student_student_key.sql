
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select student_key
from "student_performance"."analytics_dimensions"."dim_student"
where student_key is null



  
  
      
    ) dbt_internal_test