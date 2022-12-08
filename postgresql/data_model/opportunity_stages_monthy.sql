select
    date_trunc('month',ds)::date as ds,
    a.account_id,
    a.account_name,
    count(case when stage = 'Prospecting' then opportunity_id else null end) as Prospecting,
    count(case when stage = 'Qualification' then opportunity_id else null end) as Qualification,
    count(case when stage = 'Needs Analysis' then opportunity_id else null end) as Needs_Analysis,
    count(case when stage = 'Value Proposition' then opportunity_id else null end) as Value_Proposition,
    count(case when stage = 'Id. Decision Makers' then opportunity_id else null end) as Id_Decision_Makers,
    count(case when stage = 'Perception Analysis' then opportunity_id else null end) as Perception_Analysis,
    count(case when stage = 'Proposal/Price Quote' then opportunity_id else null end) as Proposal_Price_Quote,
    count(case when stage = 'Negotiation/Review' then opportunity_id else null end) as Negotiation_Review,
    count(case when stage = 'Closed Won' then opportunity_id else null end) as closed_won,
    count(case when stage = 'Closed Lost' then opportunity_id else null end) as closed_lost
from
    sales_service_cloud.account as a
left join sales_service_cloud.opportunity_monthly as o
    on (o.account_id = a.account_id)
group by 1,2,3
