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

**ANSWER: 2**
<br><br>

![Sample Image](../images/module2/kes_3.png)
<br><br>

----------------------------------------------------------------------------------------------
4- How many rows are there for the Green Taxi data for all CSV files in the year 2020?<br>
1- 5,327,301<br>
2- 936,199<br>
3- 1,734,051<br>
4- 1,342,034<br>

**ANSWER: 3**
<br><br>

![Sample Image](../images/module2/kes_4.png)
<br><br>

----------------------------------------------------------------------------------------------

5- How many rows are there for the Yellow Taxi data for the March 2021 CSV file?<br>
1- 1,428,092<br>
2- 706,911<br>
3- 1,925,152<br>
4- 2,561,031<br>

**ANSWER: 3**
<br><br>

![Sample Image](../images/module2/kes_5.png)
<br><br>

----------------------------------------------------------------------------------------------

6- How would you configure the timezone to New York in a Schedule trigger?<br>
1- Add a timezone property set to EST in the Schedule trigger configuration<br>
2- Add a timezone property set to America/New_York in the Schedule trigger configuration<br>
3- Add a timezone property set to UTC-5 in the Schedule trigger configuration<br>
4- Add a location property set to New_York in the Schedule trigger configuration<br>

**ANSWER: 2**

