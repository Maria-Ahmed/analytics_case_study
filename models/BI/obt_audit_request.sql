WITH big_table AS (
  SELECT
    -- Customer details section
    customer_key, 
    c.id_organization, 
    c.id_request, 
    customer_name,  
    current_status,  
    previous_status,  
    created_date,  
    request_state,  
    signed_date,  
    audit_type,  
    audit_confirmation_date,  
    payment_term_days,  
    report_published_date,  
    audit_selected_date,  
    authorization_requested_date,  
    supplier_name,  
    supplier_country,  
    audited_product,  

    -- Credit packages section
    credit_packages_key,  
    start_date,  
    end_date,  
    payment_cycle,  
    signature_date,  

    -- Numeric values section
    fact_key,  
    f.id_credit_package,  
    credits_amount,  
    total_value_eur,  
    price_eur,  

    -- Date section
    year,  
    week,  
    day,  
    fiscal_year, 
    fiscal_qtr,  
    month,  
    month_name,  
    week_day,  
    day_name,  
    day_is_weekday, 
    loaded_at,  
    date_key, 
    ROW_NUMBER() OVER (PARTITION BY customer_key, c.id_organization, c.id_request, customer_name) AS rn
  FROM {{ref('fact_audit_requests')}} f
  LEFT JOIN {{ref('dim_customer')}} c ON f.customer_fk = c.customer_key
  LEFT JOIN {{ ref('dim_credit_packages')}} p ON f.credit_packages_fk = p.credit_packages_key
  LEFT JOIN {{ ref('dim_date')}} d ON c.created_date = d.full_date
)


SELECT
  *
FROM big_table
WHERE rn = 1
