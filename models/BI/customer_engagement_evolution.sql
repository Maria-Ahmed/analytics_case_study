WITH customer_firsts AS (
  SELECT
    customer_key,
    MIN(authorization_requested_date) AS first_audit_request,
    MIN(start_date) AS first_subscription
  FROM {{ ref('obt_audit_request')}}
  GROUP BY 1
)

SELECT
  customer_key,
  CASE
    WHEN first_audit_request IS NOT NULL AND first_subscription IS NOT NULL AND first_subscription > first_audit_request THEN 'Transitioned'
    ELSE 'Not Transitioned'
  END AS engagement_evolution
FROM customer_firsts
