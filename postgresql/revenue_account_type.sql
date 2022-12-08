
with customer_rev as (
    select
           o.account_id,
           a.account_name,
           o.opportunity_id,
           o.name as opportunity_name,
           o.stage,
           o.won,
           o.closed,
           o.opportunity_type,
           coalesce(oli.quantity * oli.sales_price, o.amount,0) as amount,
           oli.line_item_id,
           oli.list_price,
           oli.sales_price,
           o.lead_source,
           oli.quantity,
           oli.opportunity_product_name,
           oli.product_code,
           p.product_name,
           oli.product_id,
           p.product_description,
           p.product_family,
           o.probability
        from sales_service_cloud.account as a
        left join sales_service_cloud.opportunity as o
            on (o.account_id = a.account_id)
        left join sales_service_cloud.opportunity_line_item as oli
            on o.opportunity_id = oli.opportunity_id
        left join sales_service_cloud.product as p
            on (p.product_id = oli.product_id)
)
, total_opportunity_amount as (

    select
        account_id,
        account_name,
        sum(amount) as total_booking_amount
    from customer_rev
    group by 1,2
)
select
    cr.account_id,
    cr.account_name,
    opportunity_id,
    opportunity_name,
    stage,
    closed,
    won,
    probability,
    lead_source,
    case
        when (regexp_match(opportunity_name, '[ENn]C-*[UDR]*'))[1] = 'EC-D' then 'Existing Customer Downgrade'
        when (regexp_match(opportunity_name, '[ENn]C-*[UDR]*'))[1] = 'EC-U' then 'Existing Customer Upgrade'
        when (regexp_match(opportunity_name, '[ENn]C-*[UDR]*'))[1] = 'EC-R' then 'Existing Customer Replacement'
        when (regexp_match(opportunity_name, '[ENn]C-*[UDR]*'))[1] = 'NC' then 'New Customer'
        else opportunity_type end as Opportunity_type,
    product_id,
    sales_price,
    list_price,
    product_name,
    product_code,
    product_family,
    total_booking_amount,
    case
        when (total_booking_amount > 500000) then 'Tier 1'
        when (total_booking_amount < 500000 and total_booking_amount > 200000)  then 'Tier 2'
        when (total_booking_amount < 200000 and total_booking_amount > 10000) then 'Tier 3'
        else 'Not Defined'
        end as customer_account_tier,
    amount

from customer_rev as cr
left join total_opportunity_amount as ta
    on (ta.account_id = cr.account_id)
