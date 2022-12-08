select
      coalesce(date_trunc('month',c.ds::date)::date, date_trunc('month',n.ds::date)::date) as ds
    , c.account_id
    , c.account_name
    , c.account_rating as current_account_rating
    , n.account_rating as next_account_rating
    , c.annual_revenue
    , case
         when c.account_rating = n.account_rating then 'No Change'
         when lower(c.account_rating) = 'cold' and lower(n.account_rating) = 'warm' then 'Cold_to_Warm Upgrade'
         when lower(c.account_rating) = 'cold' and lower(n.account_rating) = 'hot' then 'Cold_to_Hot Upgrade'
         when lower(c.account_rating) = 'warm' and lower(n.account_rating) = 'hot' then 'Warm_to_Hot Upgrade'
         when lower(c.account_rating) = 'hot'  and lower(n.account_rating) = 'warm' then 'Hot_to_Warm downgrade'
         when lower(c.account_rating) = 'hot'  and lower(n.account_rating) = 'cold' then 'Hot_to_Cold downgrade'
         when lower(c.account_rating)  = 'warm' and lower(n.account_rating) = 'cold' then 'Warm_to_Cold downgrade' end as Change_in_rating
from sales_service_cloud.account_snapshot as c
left join sales_service_cloud.account_snapshot as n
    on (
        c.account_id = n.account_id and 
        extract(month from c.ds::date) + 1  =  extract(month from n.ds::date) 
    )