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
