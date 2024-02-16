{% macro test_customer_engagement_evolution(model) %}

WITH customer_firsts AS (
  SELECT
    customer_key,
    MIN(authorization_requested_date) AS first_audit_request,
    MIN(start_date) AS first_subscription
  FROM {{ model }}
  GROUP BY customer_key
)

SELECT
  customer_key,
  CASE
    WHEN first_audit_request IS NOT NULL 
         AND first_subscription IS NOT NULL 
         AND first_subscription <= first_audit_request THEN customer_key
    ELSE NULL
  END AS invalid_customer_key
FROM customer_firsts
WHERE invalid_customer_key IS NOT NULL

{% endmacro %}
