Deduplication: we use the same 2 fields (`vendorid, lpep_pickup_datetime`) for the `row_number()` that we used to generate the surrogate keyf which means we are trying to find duplicates of that primary key of rows that have the same primary key and then filter thoes duplicated rows with `rn=1` to maintain only one of those duplicates.

<h3>What is {% ... %} in dbt (Jinja)?</h3>
In dbt (and Jinja templating), {% ... %} is used for control statements like:<br><br>

**Conditional logic (if, else)**
**Loops (for)**
**Macro calls** <br>
These are different from {{ ... }}, which is used for expressions that return values (like column names or variables).

<h4>🔹 Example: {% if ... %} (Conditional Statement)</h4>
```python
{% if var('is_test_run', default=true) %}
  limit 100
{% endif %}```
✔ If is_test_run = true, dbt adds LIMIT 100 to the SQL.
✔ If is_test_run = false, dbt skips LIMIT 100.

🔹 {% for ... %} (Loop Example)
Loops through values:

jinja
Copy
Edit
{% for col in ['col1', 'col2', 'col3'] %}
  SUM({{ col }}) AS sum_{{ col }},
{% endfor %}
✔ This generates:

sql
Copy
Edit
SUM(col1) AS sum_col1,
SUM(col2) AS sum_col2,
SUM(col3) AS sum_col3,
🔹 {% set ... %} (Variable Assignment)
jinja
Copy
Edit
{% set threshold = 100 %}
✔ Stores 100 in threshold and can be used later like:

jinja
Copy
Edit
WHERE value > {{ threshold }}
🔹 {% macro ... %} (Creating a Macro)
jinja
Copy
Edit
{% macro get_limit() %}
  limit 100
{% endmacro %}
✔ Can be reused inside a model:

jinja
Copy
Edit
SELECT * FROM my_table {{ get_limit() }}



Select all fields from both the green and yellow trip data using ref() for references and add a service_type column to distinguish the datasets.

Union the data to create a combined dataset (trips_union).

Join trips_union with dim_zones for both pickup and drop-off zones to associate zone names and other details. what is going to happen is that if there is a trip with an unknown zone (not valid zone), we miss that trip. Only valid zones will be included (e.g., exclude unknown zones).

Table: A table is a database object that stores data in rows and columns. 

View: A view is a virtual table that is based on a SELECT query from one or more underlying tables. It does not store data itself but provides a way to present and manipulate data from these tables in a specific format. 

Run `dbt deps` to install the package.
