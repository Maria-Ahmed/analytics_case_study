SELECT 
    customer_name, 
    id_organization,  
    credits_amount, 
    total_value_eur,
    AVG(price_eur) AS average_audit_price, 
    COUNT(id_request) AS total_requests
FROM {{ ref('obt_audit_request') }}
GROUP BY 1, 2, 3, 4
