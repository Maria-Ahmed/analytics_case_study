-- Define a Common Table Expression (CTE) named 'source' to load data from the specified source table
with source as (
    select * from {{ source('public', 'raw_data_credit_packages') }}
),

-- Define another CTE named 'renamed' to format and cast column data types as needed
renamed as (
    select
        id_credit_package,  -- Retain the credit package ID as is
        CAST(signature_date AS DATE) AS signature_date,  -- Convert signature_date to DATE type
        CAST(start_date AS DATE) AS start_date,  -- Convert start_date to DATE type
        CAST(end_date AS DATE) AS end_date,  -- Convert end_date to DATE type
        CAST(credits_amount AS INT) credits_amount,  -- Convert credits_amount to INTEGER type
        CAST(total_value_eur AS FLOAT) AS total_value_eur,  -- Convert total_value_eur to FLOAT type
        payment_cycle,  -- Retain the payment cycle as is
        id_subscription,  -- Retain the subscription ID as is
        id_organization  -- Retain the organization ID as is      
    from source  -- Select data from the 'source' CTE
)

-- Final SELECT statement to retrieve all rows from the 'renamed' CTE
select * from renamed
