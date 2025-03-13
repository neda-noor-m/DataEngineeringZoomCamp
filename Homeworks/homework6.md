<h2>Question 1: Redpanda version</h2>
Now let's find out the version of redpandas.<br>

For that, check the output of the command rpk help inside the container. The name of the container is redpanda-1.<br>

Find out what you need to execute based on the help output.<br>

What's the version, based on the output of the command you executed? (copy the entire version)<br><br>
**answer: rpk version v24.2.18**
______________________________________________________________________________________
<h2>Question 2. Creating a topic</h2>
Before we can send data to the redpanda server, we need to create a topic. We do it also with the rpk command we used previously for figuring out the version of redpandas.<br><br>

Read the output of help and based on it, create a topic with name green-trips<br>

What's the output of the command for creating a topic? Include the entire output in your answer.<br><br>
**answer:** <br>
TOPIC        STATUS <br>
green-trips  OK
_______________________________________________________________________________________________
<h2>Question 3. Connecting to the Kafka server</h2>
We need to make sure we can connect to the server, so later we can send some data to its topics<br><br>

First, let's install the kafka connector (up to you if you want to have a separate virtual environment for that)<br><br>

`pip install kafka-python`
You can start a jupyter notebook in your solution folder or create a script

Let's try to connect to our server:

```python
import json

from kafka import KafkaProducer

def json_serializer(data):
    return json.dumps(data).encode('utf-8')

server = 'localhost:9092'

producer = KafkaProducer(
    bootstrap_servers=[server],
    value_serializer=json_serializer
)

producer.bootstrap_connected()
```
Provided that you can connect to the server, what's the output of the last command? <br>

**answer: True**
______________________________________________________________________________________________

<h2>Question 4: Sending the Trip Data </h2>
Now we need to send the data to the green-trips topic<br><br>

Read the data, and keep only these columns:<br><br>

'lpep_pickup_datetime',<br>
'lpep_dropoff_datetime',<br>
'PULocationID',<br>
'DOLocationID',<br>
'passenger_count',<br>
'trip_distance',<br>
'tip_amount'<br>
Now send all the data using this code:<br><br>

producer.send(topic_name, value=message)<br>
For each row (message) in the dataset. In this case, message is a dictionary.<br><br>

After sending all the messages, flush the data:<br>
```python
producer.flush()
Use from time import time to see the total time

from time import time

t0 = time()

# ... your code

t1 = time()
took = t1 - t0
```
How much time did it take to send the entire dataset and flush?<br><br>

```python
tim0 = time()

for _, row in df_h6.iterrows():
    message = row.to_dict()
    producer.send(topic_name, value=message)
producer.flush()

t1 = time()
took = t1 - tim0

print(f"Time taken to send dataset: {took:.2f} seconds")
```
**answer: 92.98 seconds**
