SELECT
    fact_key,
    credits_amount
FROM {{ ref('fact_audit_requests') }}
WHERE credits_amount > {{ var('max_credits_allowed', 1000) }}
