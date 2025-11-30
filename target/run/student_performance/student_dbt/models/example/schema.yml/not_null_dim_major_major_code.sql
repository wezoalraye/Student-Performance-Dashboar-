
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select major_code
from "student_performance"."analytics_dimensions"."dim_major"
where major_code is null



  
  
      
    ) dbt_internal_test