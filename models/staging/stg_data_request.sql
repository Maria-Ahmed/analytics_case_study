-- Define a CTE named 'source' to extract data from the raw_data_requests table
with source as (
    select * from {{ source('public', 'raw_data_requests') }}
), 

-- Define another CTE named 'renamed' to clean and rename columns
renamed as (
    select
        id_request, -- Keep the request ID as is
        CAST(created_date AS DATE) AS created_date, -- Convert created_date to DATE type
        INITCAP(REPLACE(request_state,'_',' ')) AS request_state, -- Beautify request_state by replacing underscores with spaces and capitalizing
        CAST(price_eur AS FLOAT) AS price_eur, -- Convert price_eur to FLOAT type
        CAST(signed_date AS DATE) AS signed_date, -- Convert signed_date to DATE type
        id_audit, -- Keep the audit ID as is
        audit_type, -- Keep the audit type as is
        CAST(audit_confirmation_date AS DATE) AS audit_confirmation_date, -- Convert audit_confirmation_date to DATE type
        customer_name, -- Keep the customer name as is
        id_organization AS id, -- Rename id_organization to id
        payment_term_days, -- Keep payment terms as is
        CAST(report_published_date AS DATE) AS report_published_date, -- Convert report_published_date to DATE type
        CAST(audit_selected_date AS DATE) AS audit_selected_date, -- Convert audit_selected_date to DATE type
        CAST(authorization_requested_date AS DATE) AS authorization_requested_date, -- Convert authorization_requested_date to DATE type
        supplier_name, -- Keep the supplier name as is
        supplier_country, -- Keep the supplier country as is
        audited_product -- Keep the audited product name as is
    from source -- Reference the 'source' CTE
)

-- Final query to select everything from the 'renamed' CTE
select * from renamed
