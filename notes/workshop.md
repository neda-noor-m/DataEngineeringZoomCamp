<h2>enrichment dataset</h2>
let's say we have already a table. we want to add an extra culomn to it from another source. can we dlt do that? or Would it be better to load data to a seprated table and then join it with table wa already have? 
answer: we dont recommend to use several differnt sources and to load to the same table. it is better to load to differnt tables and then join them. But you can do that with dlt since dlt is python based. Look for something like map functions, enrichment dataset in documentations.
