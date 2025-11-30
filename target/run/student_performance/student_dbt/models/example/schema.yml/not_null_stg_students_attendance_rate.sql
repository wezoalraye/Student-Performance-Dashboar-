
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select attendance_rate
from "student_performance"."analytics_staging"."stg_students"
where attendance_rate is null



  
  
      
    ) dbt_internal_test