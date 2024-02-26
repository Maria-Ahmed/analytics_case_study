# Case Study Scenario
Company X operating on a transactional model, has strategically shifted to a subscription-based model to foster long-term client relationships and ensure a stable revenue stream. This transition is central to their data strategy and presents unique challenges and opportunities for data analysis and modeling.
The project aims to answer the business questions based on *Customer Engagement Evolution*, *Subscription Data Integration*, and *Credit Package Utilization and Expiry Analysis*


## Technicalities Considered:
- Designing and Implementing effective data models using DBT.
- Usage of normalization and denormalization techniques in data modeling.
- Showcasing the depth of knowledge in DBT & SQL.
- Implementing DBT tests ensuring data quality and integrity.


## Tools Used:
- **DBT:** Transformation 
- **Metabase:** Visualization
- **Postgres:** Data Warehouse

## Initial Set Up:
1. For the data extraction part, either load the CSV using `dbt seeds`, or run Python script (which initiates a connection to a PostgreSQL database using SQLAlchemy and then reads a CSV file into a pandas DataFrame.) Also, configure the dbt profiles.yml file separately. 

2. Then execute a custom operation called `generate_base_model`, passing in the arguments `source_name` with a value of `public` and `table_name` with a value of `raw_data_requests`. It generated a base model from the `public` schema.

3. Run `generate_source`, passing in the arguments `schema_name` with a value of "public" and `generate_columns` set to true. It processes the schema, including its columns, in the `source.yml` file. Then from it, into the staging files eg: `stg_data_request` brings all the fields from `raw_layer` in the staging_layer.



# Data Modeling 
Used, Star schema has denormalized dimension tables. In this scenario I kept 2 fact tables, entertaining each of the business models for simplicity, and built upon their dimensions.

I created 1 fact table: Fact Table - fact_audit_requests:
This captures all the audit request data along with customer and credit package details.
In the 'source CTE’' surrogate keys are generated and it aggregates the data. Applies normalization techniques to ensure data integrity. Handled duplicates using the ROW_NUMBER() function.

### Created 3 dimensions Namely:
- Customers
- Credit Packages
- Dates

For the customer dimension, I integrated customer and credit package data. The way I track status changes for customers is similar to what can be categorized as Slowly Changing Dimension Type 3 (SCD Type 3).

For dim_credit_packages, integrate credit package data with optional request data, generating a unique key for each credit package. Coalesces organization ID to ensure its presence.

For dim_date, I  generated a comprehensive date dimension table. Felt the need to format date attributes and extract various date components such as year, week, day, month, and day of the week. Then utilized a Macro for the same, which applies a custom function day_is_weekday to determine if the day is a weekday. Consequently at the end, generating a unique surrogate key for each date.

Lastly, at the end, I retrieved comprehensive information about customers, their associated credit packages, and relevant numeric and date attributes, and then filtered the result to include only the first occurrence of each customer within their respective partitions



## Complete Documentation
For a detailed overview of the documentation, [click here](https://docs.google.com/document/d/1vupPREntZm1Orgefxd2ylUCLQsIVVLNfqe2uXVZYd4Y/edit).

