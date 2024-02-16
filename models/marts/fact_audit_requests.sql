
WITH fact_table AS (
    SELECT
        {{ dbt_utils.generate_surrogate_key(['id_request', 'customer_name']) }} AS fact_key,  --  unique key for each fact record
        {{ dbt_utils.generate_surrogate_key(['customer_name']) }} AS customer_fk, 
        {{ dbt_utils.generate_surrogate_key(['id_credit_package']) }} AS credit_packages_fk,  
        COALESCE(dr.id, cp.id_organization) AS id_organization,  -- to ensure organization ID is always populated
        dr.id_request, 
        cp.id_subscription,  
        cp.id_credit_package,
        cp.credits_amount, 
        cp.total_value_eur, 
        dr.price_eur  
    FROM {{ ref('stg_data_request') }} dr  
    LEFT JOIN {{ ref('stg_data_credit_packages') }} cp ON dr.id = cp.id_organization  
),
deduplication AS (
    SELECT 
        *,
        ROW_NUMBER() OVER (PARTITION BY id_request, customer_fk, credit_packages_fk) AS rn
    FROM fact_table
)

SELECT
    *
FROM deduplication
WHERE rn = 1
