
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    

select
    major_key as unique_field,
    count(*) as n_records

from "student_performance"."analytics_dimensions"."dim_major"
where major_key is not null
group by major_key
having count(*) > 1



  
  
      
    ) dbt_internal_test