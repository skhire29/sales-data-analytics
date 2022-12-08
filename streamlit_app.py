import streamlit as st
import psycopg2
import pandas as pd
import altair as alt

# Initialize connection.
# Uses st.experimental_singleton to only run once.
@st.experimental_singleton
def init_connection():
    return psycopg2.connect(**st.secrets["postgres"])

conn = init_connection()

# Perform query.
# Uses st.experimental_memo to only rerun when the query changes or after 10 min.
@st.experimental_memo(ttl=600)
def run_query(query):
    with conn.cursor() as cur:
        cur.execute(query)
        colnames = [desc[0] for desc in cur.description]
        return colnames, cur.fetchall()

names, rows = run_query("SELECT * from salesforce_db.sales_service_cloud.account_product_revenue limit 10")

def plot_chart(sql, title, chart_type, x = None, y = None, width = 40, height = 500, numeric_colunmn = None):

    names, rows = run_query(sql)
    dataframe = pd.DataFrame(rows, columns=names)

    if chart_type == 'bar':
        st.header(title)
        tab1, tab2 = st.tabs(["📈 Chart", "🗃 Data"])
        tab1.subheader("Bar chart")
        tab1.bar_chart(data = dataframe, x = x, width = width , height = height)
        tab2.subheader("Data")
        tab2.write(dataframe)
    if chart_type == 'data':
        st.header(title)
        st.write(dataframe)
    if chart_type == 'chart':
        st.header(title)
        tab1, tab2 = st.tabs(["📈 Chart", "🗃 Data"])
        tab1.subheader('Bubble Chart')
        tab2.subheader('Data')
        dataframe[numeric_colunmn] = dataframe[numeric_colunmn].apply(pd.to_numeric)
        c = alt.Chart(data= dataframe, height = 500).mark_circle().encode(
            y=y, x=x, size=numeric_colunmn, color=numeric_colunmn)

        tab1.altair_chart(c, use_container_width=True)
        tab2.write(dataframe)

def plot_selection_chart():
    query = f"""
        select distinct account_name from sales_service_cloud.opportunity_stages_monthy
    """

    names, rows = run_query(query)
    account_list = []
    for row in rows:
        account_list.append(row[0])
    dataframe = pd.DataFrame(rows, columns=names)
    selection = st.multiselect('Account',  account_list)
    print(selection)

    query = f"""
    select
        ds,
        account_id,
        account_name,
        prospecting,
        qualification,
        needs_analysis,
        value_proposition,
        perception_analysis,
        proposal_price_quote,
        negotiation_review,
        closed_lost,
        closed_won
    from 
    sales_service_cloud.opportunity_stages_monthy
    """
    names, rows = run_query(query)
    dataframe = pd.DataFrame(rows, columns=names)
    df = dataframe[dataframe['account_name'].isin(selection)]
    st.write(df)
    stages = [ 'prospecting',
        'qualification',
        'needs_analysis',
        'value_proposition',
        'perception_analysis',
        'proposal_price_quote',
        'negotiation_review',
        'closed_lost',
        'closed_won']

    stage_selection = st.selectbox('Stage',  stages)
    c = alt.Chart(data= df, height = 500).mark_bar().encode(
                y=stage_selection, x='ds')
    tab1, tab2 = st.tabs(["📈 Chart", "🗃 Data"])

    tab1.write(df[['ds',stage_selection]])
    tab2.altair_chart(c, use_container_width=True)



st.title('Sales Data Analytics')

query1 = f"""select
                date_trunc('month',ds)::date as ds,
                count(case when current_account_rating = 'cold' then 1 else 0 end) as cold,
                count(case when current_account_rating = 'warm' then 1 else 0 end) as warm,
                count(case when current_account_rating = 'hot' then 1 else 0 end) as hot
                from sales_service_cloud.account_rating_changes
                group by 1 order by ds;
"""

query2 = f"""
select
    count(account_name), change_in_rating
from sales_service_cloud.account_rating_changes where change_in_rating is not null
group by 2;
"""

query3 = f"""
    select stage_change, count(opportunity_id) as number_of_opportunity from sales_service_cloud.opportunity_stage_changes
    where stage_change is not null
    group by 1;
"""

query4 = f"""
    select 
          case 
               when opportunity_type ilike '%replacement%' then 'Existing Customer Replacement'
               when opportunity_type ilike '%downgrade%' then 'Existing Customer Downgrade'
               when opportunity_type ilike '%upgrade%' then 'Existing Customer Upgrade'
               else opportunity_type end as opportunity_type
        , count(distinct opportunity_id) as opportunities
        from sales_service_cloud.revenue_account_type
        where opportunity_type is not null
    group by 1
;

"""

query5 = f"""
    select
    *
    from (
        select
        customer_account_tier,
        account_name,
        count(distinct opportunity_id) opportunity_count,
        sum(amount) as total_revenue,
        dense_rank() over (partition by customer_account_tier order by sum(amount) desc) as rank
        from sales_service_cloud.revenue_account_type
        where customer_account_tier != 'Not Defined'
        group by 1,2
    ) as sub where rank <= 5

"""

query6 = f"""
    select lead_source, count(account_id) converted_accounts from sales_service_cloud.lead_conversion
    where opportunity_id is not null
    group by 1;

"""

with st.container():
    plot_chart(query1, 'Account Rating Each month', 'bar', x = 'ds')
    plot_chart(query2, 'Changes in Account Rating', 'bar', x = 'change_in_rating')
    plot_chart(query3, 'Changes in Opportunity Stage', 'bar', x = 'stage_change')
    plot_chart(sql = query4, title = 'Type Of Customer Opportunity',chart_type = 'bar', width = 40, height = 500, x = 'opportunity_type')
    plot_chart(sql = query5, title = 'Account Tier and Revenue', chart_type = 'chart', y = 'customer_account_tier', x = 'account_name', numeric_colunmn = 'total_revenue')
    plot_chart(query6, 'Leads Converted', 'bar', x = 'lead_source')
    plot_selection_chart()

