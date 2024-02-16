WITH all_customers AS (
    SELECT    
        {{ dbt_utils.generate_surrogate_key(['customer_name']) }} AS customer_key, -- its a unique key based on customer name
        dr.customer_name,
        COALESCE(dr.id, cp.id_organization) AS id_organization, -- Use request ID or fallback to credit package's organization ID
        CASE 
            WHEN dr.id IS NOT NULL AND cp.id_organization IS NOT NULL THEN 'Subscription' -- Mark as 'Subscription' if both IDs exist
            WHEN dr.id IS NULL AND cp.id_organization IS NOT NULL THEN 'Subscription' -- Mark as 'Subscription' for new customers directly subscribing in 2023
            WHEN dr.id IS NOT NULL AND cp.id_organization IS NULL THEN 'Transaction' -- Mark as 'Transaction' for transaction-only interactions
            ELSE NULL -- Mark as NULL if neither condition is met
        END as current_status,
        CASE 
            WHEN dr.id IS NOT NULL AND cp.id_organization IS NOT NULL THEN 'Transaction' -- Previous status as 'Transaction' if transitioning to subscription
            ELSE NULL -- Leave as NULL if no previous status exists
        END as previous_status,
        id_request, 
        created_date, 
        request_state, 
        signed_date, 
        id_audit, 
        audit_type, 
        audit_confirmation_date, 
        payment_term_days, 
        report_published_date, 
        audit_selected_date, 
        authorization_requested_date, 
        supplier_name,
        supplier_country,
        audited_product, 
        ROW_NUMBER() OVER (PARTITION BY id_request, created_date, customer_name) AS rn 
    FROM  
        {{ ref('stg_data_request') }} dr 
        LEFT JOIN {{ ref('stg_data_credit_packages') }} cp ON dr.id = cp.id_organization 
) 
SELECT 
    * 
FROM all_customers
WHERE rn = 1 
