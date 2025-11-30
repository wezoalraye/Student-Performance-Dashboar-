
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select performance_key
from "student_performance"."analytics_dimensions"."dim_performance_category"
where performance_key is null



  
  
      
    ) dbt_internal_test