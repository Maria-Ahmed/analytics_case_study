{% macro test_expiring_credits_accuracy(model) %}

WITH validation AS (
    SELECT
        *,
        CASE
            WHEN expiring_credits < 0 THEN FALSE
            ELSE TRUE
        END AS is_valid
    FROM {{ model }}
)

SELECT COUNT(*)
FROM validation
WHERE is_valid = FALSE

{% endmacro %}
