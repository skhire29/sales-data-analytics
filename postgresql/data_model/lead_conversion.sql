select
    l.lead_id,
    l.lead_source,
    case when a.account_id is not null then 'converted'
         when a.account_id is null then 'not converted'  end as converted_status,
    a.account_id,
    a.account_name,
    o.opportunity_id,
    o.name as opportunity_name,
    c.contact_id,
    c.first_name || ' ' || c.last_name as contact_full_name
from sales_service_cloud.lead as l
left join sales_service_cloud.account as a
    on a.account_id = l.converted_account_id
left join sales_service_cloud.opportunity as o
    on o.opportunity_id = l.converted_opportunity_id
left join sales_service_cloud.contact as c
    on c.contact_id = l.converted_contact_id
