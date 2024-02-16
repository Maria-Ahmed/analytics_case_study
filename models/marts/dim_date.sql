WITH aggregated_dates AS (
    SELECT
        TO_CHAR(d, 'YYYY-MM-DD') AS id, 
        d AS full_date, 
        EXTRACT(YEAR FROM d) AS year, 
        EXTRACT(WEEK FROM d) AS week, 
        EXTRACT(DAY FROM d) AS day, 
        EXTRACT(YEAR FROM d) AS fiscal_year, 
        TO_CHAR(d, 'Q') AS fiscal_qtr, 
        EXTRACT(MONTH FROM d) AS month, 
        TO_CHAR(d, 'Month') AS month_name, 
        EXTRACT(DOW FROM d) AS week_day, 
        TO_CHAR(d, 'Day') AS day_name, 
        {{ day_is_weekday('d') }} AS day_is_weekday, 
        current_timestamp AS loaded_at 
    FROM (
        SELECT
            *
        FROM
            generate_series('2019-09-01'::DATE, '2050-05-01'::DATE, INTERVAL '1 day') AS d -- producesa series of daily dates
    ) x
)
SELECT
    *,
    {{ dbt_utils.generate_surrogate_key(['id']) }} AS date_key -- a unique surrogate key for each date
FROM aggregated_dates
