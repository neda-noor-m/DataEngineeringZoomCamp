docker-compose down --volumes --remove-orphans

[h1]what does `Kestra` look like?[h1]
[Watch Video](https://www.youtube.com/watch?v=Np6QmmcgLCs)
 
a workflow starts with: 
1- an Id which is the name of workflow and must be uniqe in `kestra` 
2- namespace which is like a folder
3- inputs like parametres are passed to workflow at the start point. at the below, we define an array with 2 fields :
```python
inputs:
  -id: columns_to_keep
   type: ARRAY
   itemType: STRING
   defaults:
      - brand
      - price
```
during execution, we can change the values of defaults and get different result. we can reffere it during the code as `{{ inputs.variable_name }}`

4- taks: 
```python
tasks:
  - id: extract
    type: io.kestra.http.downlaod
    uri: wget https://github.com/DataTalksClub/nyc-tlc-data/releases/download/green/green_tripdata_2019-10.csv.gz

  - id: transform
    type: io.kestra.plugin.scripts.pyhton.Script
    containerimage: ...
    imputFiles:
      data.json: "{{ outputs.extract.uri }}"
   #the rest of code

  - id: query
    type: io.kestra...query
    inputFiles:
      products.json: "{{ outputs.transform.outputsfiles['products.json'] }}"
    sql:
      
```
lets say our first task is to extract data from the the link mentioned in `url` feild above. the second task is to transform our data which is a python script. this script could be inside of this code or outside of this code as a seprated file. as you see, we care getting the data from last task by `imputFiles` parameter. afterwards, we pass the product.json to the query. 

5- triggers: it makes that flow executes when the condition meets. it could be a schedule.

```python
triggers:
   - id: hour_trigger
     type: ...
     cron: 0 * * * *
```

**how to start `kestra` as a docker**
```python
docker run --pull=always --rm -it -p 8080:8080 --user=root -v /var/run/docker.sock:/var/run/docker.sock -v /tmp:/tmp kestra/kestra:latest server local
```


to make sure this works we will one property called namespaceFile and set it up to True otherwise the task wont be able to see the file in the editor.

<h1>2. Hands-On Coding Project: Build Data Pipelines with Kestra</h1>
<h3>Load Data to Local Postgres</h3>
because we are going use a few queries here, we are going to use `pluginDefaults`to allow us to be able set the URL username and pasword for all postgres tasks. This is useful if we end up using differnt databases using differnt connection URL, we havent got to update it in all locations. so we added `pluginDefaults` at the end of file.

```python
pluginDefaults:
  - type: io.kestra.plugin.jdbc.postgresql
    values:
      url: jdbc:postgresql://host.docker.internal:5432/postgres-zoomcamp
      username: kestra
      password: k3str4
```

<h1>4. ETL Pipelines in Kestra: Google Cloud Platform</h1>
To be more specific, we'll continue extracting data from our CSV files as we did previously, but this time, instead of loading them into Postgres, we’ll upload them directly to Google Cloud Storage. Once the data is there, BigQuery will automatically generate tables from these files, enabling us to process the data and run queries. This approach follows the same process as before, with the added benefit of being able to manage the Yellow Taxi files, which were previously too large for efficient processing in Postgres.<br><br>

**Note on BigQuery vs. Google Cloud Storage:** <br>
1- **BigQuery** functions as a data warehouse, designed to store structured data for fast querying and analysis. It is optimized for running SQL queries on large datasets, making it ideal for transforming and analyzing data that has already been structured and loaded into tables.<br>

2- **Google Cloud Storage**, on the other hand, serves as a data lake where raw, unstructured, or semi-structured data can be stored. It allows us to store vast amounts of data in any format (like CSVs or JSON) before it's processed. In our case, we use it to house the CSV files before BigQuery takes over for analysis.

In short, Google Cloud Storage is where we land raw data, and BigQuery is where we process and analyze it efficiently.
<h2>Setup GCP</h2>
First we need to set up our GCP credentials such as our google cloud service account, project ID, location regein, BigQuery dataset, bucket name. The flow `04_gcp_kv.yaml` stores these values as KV (Key Value) Store values.In Kestra, KV Store values are a kind of environment variables file.<br>

fill in the values needed for keys in the flow `04_gcp_kv.yaml` and execute the code. If you go to KV Store found in Namespaces->zoomcamp->KV Store you will see all KVs are added.
<h2>05_GCP_setup</h2>
What we're gonna do here is to create GCP resources. We here again use `pluginDefualts` for not to have to repeat some code. 
