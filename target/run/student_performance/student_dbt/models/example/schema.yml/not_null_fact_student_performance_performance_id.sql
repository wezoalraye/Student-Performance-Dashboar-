
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select performance_id
from "student_performance"."analytics_facts"."fact_student_performance"
where performance_id is null



  
  
      
    ) dbt_internal_test