<h1>Quiz Questions</h1>
1- Within the execution for Yellow Taxi data for the year 2020 and month 12: what is the uncompressed file size (i.e. the output file yellow_tripdata_2020-12.csv of the extract task)?<br>
1- 128.3 MB<br>
2- 134.5 MB<br>
3- 364.7 MB<br>
4- 692.6 MB<br><br>

**ANSWER: 1**
<br><br>

![Sample Image](../images/module2/kes_1.png)
<br><br>

----------------------------------------------------------------------------------------------
2- What is the rendered value of the variable file when the inputs taxi is set to green, year is set to 2020, and month is set to 04 during execution?<br>
1- {{inputs.taxi}}_tripdata_{{inputs.year}}-{{inputs.month}}.csv<br>
2- green_tripdata_2020-04.csv<br>
3- green_tripdata_04_2020.csv<br>
4- green_tripdata_2020.csv<br>

we need just to substitute the values `green`,`2020`, and`04` respectively with the`inputs.taxi`,`inputs.year`, and`inputs.month`in the expression`{{inputs.taxi}}_tripdata_{{inputs.year}}-{{inputs.month}}.csv`. we will get green_tripdata_2020-04.csv as the result.

**ANSWER: 2**
<br>

----------------------------------------------------------------------------------------------
3- How many rows are there for the Yellow Taxi data for all CSV files in the year 2020?<br>
1- 13,537.299<br>
2- 24,648,499<br>
3- 18,324,219<br>
4- 29,430,127<br>


