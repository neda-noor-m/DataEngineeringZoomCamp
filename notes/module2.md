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
