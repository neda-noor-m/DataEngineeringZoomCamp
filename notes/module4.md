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


---------------------------------------------------------------------------------
DataTalksClub
Data Engineering Zoomcamp 2024 Cohort
Week 4: Analytics Engineering
https://github.com/DataTalksClub/data-engineering-zoomcamp/tree/main/04-analytics-engineering
DE Zoomcamp 4.3.2 - Testing and Documenting the Project

We have already created a functioning project in dbt. In this project, we have learned how to create various models of voice tables and views using our resources. We have also learned how to use macros, change variables, and use packages.

In order to make our development process easier and more modular, we will now enhance our project by adding testing and documentation. Although testing and documentation are not mandatory, we have already seen the benefits of running models and how it affects our data warehouse. Therefore, it is highly recommended to have a well-developed project.

Let's begin by conducting a test. A test is an assumption that we make about our data, representing a behaviour that our data should exhibit in dbt. A test is similar to a model or a select query. This means that we will execute a dbt test, which will compile into a SQL query and return the number of records that fail to meet our assumptions.

The purpose of this test is to determine the number of records that do not adhere to the assumptions we have made about our data. If there are any such records, the test will display the count of failing records in the terminal. For example, in the test results shown here, we can observe a warning and three records that do not meet our assumptions.

The tests are defined in **the YAML file under the column name**. dbt provides us with four basic tests that we can add to our columns to check for uniqueness, acceptance within specified values, or a foreign key relationship with another table. The YAML file demonstrates how these tests are defined.

The column name is displayed here. You can find a description for it in the documentation. The tests linked to this column are shown under the "Test" section. For example, in the "trip_id" column, there are two tests: "unique" and "not now". You can see the results of running the tests from the target folder.

I can display the compiled code for the "not null" test. Here, it checks if the ‘’trip_id’’ is not null, which means it always checks against the actual assumption. If the test gives a result, it means the test has failed. If it doesn't give a result, it means the test has passed. The same applies to macros. If you can create a query for your assumption, you can create a custom test.

Alternatively, you can use packages and import them to use pre-made tests from dbt utils. These tests can be helpful for macros as well. They offer a variety of tests that you can try in your project. As mentioned before, there is also a description linked to the column. This is because dbt provides a way to generate documentation for the entire project.

We can also render this documentation as a website. We have already learned how to document comments, but you can also document the model. dbt recognizes whatever you write in the YAML file, including descriptions, tests, and sources.

With the code from your models, compiled code with ref macros, and the generated documentation, dbt will render all of this into a website. The website will have a similar appearance to the one shown, and it will also include additional information retrieved from your data warehouse. This website can be embedded in dbt cloud.

If you're running in the terminal, you can run dbt locally by using "dbt docs generate" and "dbt docs serve". This will allow you to access it on your local host. Now let's go back to our project and see it from dbt cloud. I have already created the dm monthly sum revenue, which I copied from the finished repo.

Just keep in mind that one of the fields is commented out and it has a different syntax for PostGres. Make sure to adapt it to the syntax you're using. Now, I'm going to the schema ml under the station folder. We originally defined this part in the YAML file. The mandatory part that we always have to add is the sources, otherwise dbt wouldn't know how to resolve the location of those sources.

But we can also add another section for our models. Without this section, dbt would still run, but it's encouraged to include it. I have already copied it from the finished repo. Here, we will see the definition of the model's name. Under that, there's a description. If it's a short description, you can write it here. Otherwise, you can use the symbol and write a whole paragraph.

Under columns, you can define as many columns as you want to document. I have defined documentation for all of the columns from the original site where we used the data from. I have also defined several tests. For trip_id, I have defined the tests "unique" and "not null" with severity "warn". The severity determines if dbt should continue running if the test fails or if it should stop entirely.

A warning means that it will show a warning in the terminal, but it will continue running everything. "Never" means that it will immediately stop running the other models. Another test we have seen is the picku_location_id, which uses the relationship test.

Additionally, it will verify the existence of both the pickup location and the drop-off location in the taxi saving lookup using the location ID field. Another test will check the accepted values under the payment type, which will be applied to both green and yellow trip data.

Both green and yellow trip data have the same payment type field with the same accepted values. This means that if we want to add a new accepted value in the future, we will need to modify it in both places in the schema ml. Using a variable can be convenient, especially if we have more data.

It's important to note that I use "quote false" because the default behaviour in the project.yml is to treat the accepted values as characters. In the project.yml, we will add a new section for variables and specify the name and type of the variable we want to use.

We can define the variable as a list, similar to how we would define a list in Python. The accepted values in this case are between one to six. The "quote" issue mentioned earlier is that when the test compiles, it would treat the values as characters.

To run the dbt test, we can use the command "dbt test" and filter by a specific model. This will run all the tests linked to that model. If we know the name of a specific test, we can select it to see the results.

======
I can run dbt builds to execute all the components in my project, including the seats, tests, and models. By doing so, I can identify any warnings or errors. In this case, one test has given us two warnings, while the others have passed. The names of the tests are displayed here.

The test names combine the test, model, and field names. All of these tests have passed except for the ones that have given warnings. The warnings are related to the assumption we made about the uniqueness of the ‘’trip_id’’, which we defined as a primary key but turned out not to be unique.

It is crucial to define tests that validate the behaviour of our data. This allows us to accurately model our data. To address the issue, I will navigate to the screen and trip data, copy the missing part of the model, and paste it.

To resolve the issue, I will add the missing data to the top of the spd file. This is a typical approach for testing. Alternatively, I could modify the models if my assumption is correct but the modelling of the source data was incorrect. This could involve filtering the data, such as excluding rows where the vendor is null or selecting only the first row using the row number.

We will apply the same process to the yellow trip data. If necessary, you can modify the test to ensure accuracy. You have two options: 
1. modify your model to correctly filter the data;
2. modify your tasks to correct the assumption. 

I will not build everything from scratch, but instead run the YouTube field, which will execute everything we have created so far.

Hopefully, everything will proceed smoothly. As you can see, all the necessary steps have been completed, including the section models, macros, the C, the valley, and the test on top of the models. The station motors and other models are also in place. If you consider the DAC we discussed earlier, the order follows a similar pattern because it understands our dependencies.

The system knows the order in which to execute tasks. For example, these three tasks are not related, so they will run in parallel. However, the system will need to finish one task before moving on to another. For instance, it will need to complete the first task before running five trips. Although there is a missing documentation file, we have successfully finished the entire project after this step.

I will simply copy and paste the schema ML here, as well as the seeds and macros. You can also document the macros and review them, as they are an integral part of your project. This will encompass the entire project.



Table: A table is a database object that stores data in rows and columns. 

View: A view is a virtual table that is based on a SELECT query from one or more underlying tables. It does not store data itself but provides a way to present and manipulate data from these tables in a specific format. 

Run `dbt deps` to install the package.
