create table sales_service_cloud.account (
    account_id varchar(18) primary key ,
    account_description varchar,
    account_fax varchar,
    account_name varchar not null,
    account_number varchar,
    account_phone varchar,
    account_rating varchar,
    account_type varchar,
    active varchar,
    annual_revenue numeric,
    billing_address varchar,
    billing_city varchar,
    billing_country varchar,
    billing_state varchar,
    billing_street varchar,
    billing_zip varchar,
    clean_status varchar,
    created_date varchar,
    customer_priority varchar,
    deleted bool,
    employees integer,
    industry varchar,
    number_of_locations integer,
    parent_account_id varchar(18),
    upsell_opportunity varchar,
    FOREIGN KEY (parent_account_id) REFERENCES sales_service_cloud.account(account_id)
);



create table sales_service_cloud.contact (
    contact_id varchar(18) primary key ,
    account_id varchar,
    assistant_name varchar,
    asst_phone varchar,
    birthdate varchar,
    business_Fax varchar,
    business_Phone varchar,
    clean_status varchar,
    created_date varchar,
    deleted varchar,
    department varchar,
    email varchar,
    email_bounced_date varchar,
    email_bounced_reason varchar,
    first_name varchar,
    full_name varchar,
    last_name varchar,
    is_email_bounced varchar,
    languages varchar,
    lead_source varchar,
    level varchar,
    mobile_phone varchar,
    FOREIGN KEY (account_id) REFERENCES sales_service_cloud.account(account_id)

);



create table sales_service_cloud.product(

    product_id varchar(18) primary key,
    active bool,
    archived bool,
    created_date varchar,
    deleted bool,
    product_code varchar,
    product_description varchar,
    product_family varchar,
    product_name varchar
);



create table sales_service_cloud.case(

    case_id varchar(18) primary key ,
    account_id varchar(18),
    case_number varchar(4),
    case_origin varchar,
    case_reason varchar,
    case_type  varchar,
    closed bool,
    closed_date varchar,
    contact_email varchar,
    contact_fax varchar,
    contact_id varchar(18),
    contact_mobile varchar,
    contact_phone varchar,
    created_date varchar,
    deleted bool,
    description varchar,
    email_address varchar,
    engineering_Req_number varchar,
    escalated bool,
    internal_comments varchar,
    name varchar,
    phone varchar,
    potential_liability varchar,
    priority varchar,
    product varchar,
    product2 varchar(18),
    sla_violation varchar,
    status varchar,
    subject varchar,
    FOREIGN KEY (account_id) REFERENCES sales_service_cloud.account(account_id),
    FOREIGN KEY (contact_id) REFERENCES sales_service_cloud.contact(contact_id)
);



create table sales_service_cloud.lead (

  Lead_id varchar(18) primary key
, Annual_Revenue numeric
, City varchar
, Clean_Status varchar
, Company varchar
, Converted	bool
, Converted_Account_ID varchar(18)
, Converted_Contact_ID varchar(18)
, Converted_Date varchar
, Converted_Opportunity_ID varchar(18)
, Country varchar
, Created_Date varchar
, Deleted bool
, Description varchar
, Email	varchar
, Email_Bounced_Date varchar
, Email_Bounced_Reason varchar
, Employees	integer
, First_Name varchar
, Last_Name varchar
, Full_Name	varchar
, Industry	varchar
, Lead_Source varchar
, Mobile_Phone varchar
, Number_of_Locations integer
, Phone	varchar
, Product_Interest	varchar
, Rating varchar
, State varchar
, Status varchar
, Street varchar
, Title	varchar
, Website varchar
, Zip_code varchar(5)
, FOREIGN KEY (Converted_Account_ID) REFERENCES sales_service_cloud.account(account_id)
, FOREIGN KEY (Converted_Contact_ID) REFERENCES sales_service_cloud.contact(contact_id)
, FOREIGN KEY (Converted_Opportunity_ID) REFERENCES sales_service_cloud.opportunity(opportunity_id)
);




create table sales_service_cloud.opportunity (

    opportunity_id varchar(18) primary key ,
    account_id varchar(18),
    amount numeric,
    close_date	varchar,
    closed	bool,
    contact_id	varchar(18),
    created_date varchar,
    deleted bool,
    delivery_installation_status varchar,
    description	varchar,
    expected_amount	numeric,
    fiscal_period varchar,
    fiscal_quarter integer,
    fiscal_year	varchar(4),
    forecast_category varchar,
    has_line_item bool,
    has_open_activity bool,
    has_overdue_task bool,
    last_activity varchar,
    lead_source	varchar,
    main_competitor varchar,
    name varchar,
    opportunity_type varchar,
    probability varchar,
    quantity integer,
    stage varchar,
    tracking_number varchar,
    won bool,
    FOREIGN KEY (account_id) REFERENCES sales_service_cloud.account(account_id),
    FOREIGN KEY (contact_id) REFERENCES sales_service_cloud.contact(contact_id)
);




create table sales_service_cloud.opportunity_line_item (
    line_item_id varchar(18) primary key,
    created_date varchar,
    deleted bool,
    list_price numeric,
    opportunity_id varchar(18),
    opportunity_product_name varchar,
    price_book_entry_id varchar,
    product_code varchar,
    product_id varchar(18),
    quantity integer,
    sales_price numeric,
    total_price numeric,
    FOREIGN KEY (opportunity_id) REFERENCES sales_service_cloud.opportunity(opportunity_id),
    FOREIGN KEY (product_id) REFERENCES sales_service_cloud.product(product_id)
);



create table sales_service_cloud.case (
    case_id varchar(18) primary key,
    account_id varchar(18),
    asset_id varchar(18),
    case_number varchar,
    case_origin varchar,
    case_reason varchar(18),
    case_type varchar(18),
    closed bool,
    closed_date varchar,
    company varchar,
    contact_email varchar,
    contact_fax varchar,
    contact_id varchar,
    contact_mobile varchar,
    contact_phone varchar,
    created_by_id varchar(18),
    created_date varchar,
    deleted bool,
    email_address varchar,
    escalated varchar,
    Parent_Case_ID varchar(18),
    Phone varchar,
    potential_liability varchar,
    priority varchar,
    sla_violation varchar,
    product varchar(18),
    product2 varchar(18),
    subject varchar,
    status varchar,
    description varchar,
    FOREIGN KEY (account_id) REFERENCES sales_service_cloud.account(account_id),
    FOREIGN KEY (contact_id) REFERENCES sales_service_cloud.contact(contact_id),
    FOREIGN KEY (product2) REFERENCES  sales_service_cloud.product(product_id)
);
