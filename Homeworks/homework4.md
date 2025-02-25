[WARNING]: Test 'test.taxi_rides_ny.relationships_stg_yellow_tripdata_dropoff_locationid__locationid__ref_taxi_zone_lookup_csv_.085c4830e7' (models/staging/schema.yml) depends on a node named 'taxi_zone_lookup.csv' in package '' which was not found

solve:
This warning indicates that dbt is trying to reference a model or source named taxi_zone_lookup.csv, but it cannot find it. 
We might have a typo in our ref() function.

```python
tests:
  - name: relationships_stg_yellow_tripdata_dropoff_locationid
    description: "Ensure dropoff_location_id exists in taxi_zone_lookup.csv"
    relationships:
      to: ref('taxi_zone_lookup.csv')  # ❌ Wrong reference
      field: locationid
```

to:
```python
  to: ref('taxi_zone_lookup')  # ✅ Correct reference
```
