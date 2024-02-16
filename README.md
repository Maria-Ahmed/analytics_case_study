# My Setup

## Tools Used:
- **DBT:** Transformation 
- **Metabase + Looker:** Visualization
- **Postgres:** Data Warehouse

## Initial Process:
1. For the extraction part, source/raw, the data gets extracted using a Python script (connection to a PostgreSQL database using SQLAlchemy and then reads a CSV file into a pandas DataFrame.) Also, Configured my dbt profiles.yml file. 
- Ps: I was about to use the “dbt seeds” command to load data from a CSV file into your PostgreSQL database, but wanted to ensure each step’s dependencies are fulfilled by separate steps.

3. Then I execute a custom operation called `generate_base_model`, passing in the arguments `source_name` with a value of `public` and `table_name` with a value of `raw_data_requests`. It generated a base model from the `public` schema.

2. Ran `generate_source`, passing in the arguments `schema_name` with a value of "public" and `generate_columns` set to true. It processed the schema, including its columns, in the `source.yml` file. Then from it, in my staging files eg: `stg_data_request` I am bringing all the fields from `raw_layer` in my staging_layer.

## Complete Documentation
For a detailed overview of the documentation, [click here](https://docs.google.com/document/d/1vupPREntZm1Orgefxd2ylUCLQsIVVLNfqe2uXVZYd4Y/edit).

