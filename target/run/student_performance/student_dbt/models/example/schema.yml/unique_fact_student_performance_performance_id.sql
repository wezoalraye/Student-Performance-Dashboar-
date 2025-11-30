
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    

select
    performance_id as unique_field,
    count(*) as n_records

from "student_performance"."analytics_facts"."fact_student_performance"
where performance_id is not null
group by performance_id
having count(*) > 1



  
  
      
    ) dbt_internal_test