
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select gpa
from "student_performance"."analytics_staging"."stg_students"
where gpa is null



  
  
      
    ) dbt_internal_test