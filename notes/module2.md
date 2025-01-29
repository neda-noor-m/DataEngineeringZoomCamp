**what does `Kestra` look like?**
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
during execution, we can change the values of defaults and get different result.

4- tasks: 


