select
       coalesce(date_trunc('month',c.ds),  date_trunc('month',n.ds))::date as ds
     , c.opportunity_id
     , c.name as opportunity_name
     , a.account_id
     , a.account_name
     , c.name
     , c.stage as current_month_stage
     , n.stage as next_month_stage
     , case when c.stage = n.stage then 'No Change'
            when c.stage != n.stage then 'Change' end as stage_change
from sales_service_cloud.opportunity_monthly as c
left join sales_service_cloud.opportunity_monthly as n
    on (
       c.opportunity_id = n.opportunity_id and
       extract(month from n.ds) = extract(month from c.ds) + 1 
       )
left join sales_service_cloud.account as a
    on (a.account_id = c.account_id)