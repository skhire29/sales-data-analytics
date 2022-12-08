with customer_rev as (
    select
           o.account_id,
           a.account_name,
           o.opportunity_id,
           o.name as opportunity_name,
           o.stage,
           o.won,
           o.closed,
           o.lead_source,
           coalesce(oli.quantity * oli.sales_price, o.amount,0) as amount,
           oli.line_item_id,
           oli.list_price,
           oli.sales_price,
           oli.quantity,
           oli.opportunity_product_name,
           oli.product_code,
           oli.product_id,
           p.product_description,
           p.product_family
        from sales_service_cloud.account as a
        left join sales_service_cloud.opportunity as o
            on (o.account_id = a.account_id)
        left join sales_service_cloud.opportunity_line_item as oli
            on o.opportunity_id = oli.opportunity_id
        left join sales_service_cloud.product as p
            on (p.product_id = oli.product_id)
)
select
    account_id,
    account_name,
    count(distinct case when closed = false then opportunity_id end) as open_opps,
    count(distinct case when closed = true then opportunity_id end) as closed_opps,
    sum(case when stage = 'Closed Won' then amount else 0 end) as total_rev,
    sum(amount) as total_possible_rev,
    dense_rank() over (order by sum(case when stage = 'Closed Won' then amount else 0 end) desc) as customer_by_revenue
from customer_rev
group by 1,2