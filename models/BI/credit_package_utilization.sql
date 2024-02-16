WITH calculate_credit_utilization AS (
  SELECT
    id_credit_package,
    id_organization,
    year,
    month,
    credits_amount, -- Included credits_amount in the GROUP BY clause
    credits_amount - SUM(COALESCE(audit_selected_date, created_date) - created_date) AS remaining_credits,
    SUM(COALESCE(audit_selected_date, created_date) - created_date) AS credits_used,
    SUM(CASE
        WHEN (COALESCE(audit_selected_date, created_date) - created_date) / credits_amount > 1 THEN credits_amount
        ELSE (COALESCE(audit_selected_date, created_date) - created_date)
      END) AS utilized_credits,
    SUM(CASE
        WHEN (COALESCE(audit_selected_date, created_date) - created_date) / credits_amount <= 1 THEN credits_amount - (COALESCE(audit_selected_date, created_date) - created_date)
        ELSE 0
      END) AS unused_credits,
    SUM(CASE
        WHEN end_date <= CURRENT_DATE AND (COALESCE(audit_selected_date, created_date) - created_date) / credits_amount <= 1 THEN credits_amount - (COALESCE(audit_selected_date, created_date) - created_date)
        ELSE 0
      END) AS expiring_credits
  FROM {{ ref('obt_audit_request') }}
  GROUP BY id_credit_package, id_organization, year, month, credits_amount 
)
SELECT *
FROM calculate_credit_utilization
