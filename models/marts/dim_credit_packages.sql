WITH credit_packages AS (
  SELECT
    {{ dbt_utils.generate_surrogate_key(['id_credit_package']) }} AS credit_packages_key, 
    cp.id_credit_package,
    COALESCE(dr.id, cp.id_organization) AS id_organization, 
    cp.start_date, 
    cp.end_date, 
    cp.payment_cycle, 
    cp.signature_date,
    ROW_NUMBER() OVER (PARTITION BY id_credit_package, signature_date, id_subscription) AS rn 
  FROM 
    {{ ref('stg_data_credit_packages') }} cp 
    LEFT JOIN {{ ref('stg_data_request') }} dr 
    ON cp.id_organization = dr.id 
)


SELECT
  *
FROM credit_packages
WHERE rn = 1
