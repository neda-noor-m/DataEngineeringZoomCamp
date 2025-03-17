we want to go and create the

processed events table uh which will be

here in the in the homework uh where we

we want to go and run this query here

called processed events uh and just run

this uh ddl

and this is going to give us our data

table for Flink uh so you should end up

seeing it in here it should actually

like show up right there it is okay cool

now we have our processed events table

with the the two columns that we are

looking for amazing so this is going to

get us kind of set up

for being able to take data from uh from

Kafka to Flink to PO postgress that's

going to be the other big piece of this

puzzle so now we've worked with both uh

we saw postgress and we saw the the

Flink job manager so obviously we're

going to need to interact with all of

these containers to get this to work

because streaming is that's how

streaming works right streaming is a it

has so many different moving pieces to

it but the next thing we're going to

want to be looking at is red panda so we

want to end up adding data to Red Panda

and like we want to be we have a couple

different uh uh python files in here

that you can work with we're going to be

using this one called just producer. py

and this is going to uh add just a bunch

of um uh test data just just kind of

like just some kind of junk data that

we're going to be using uh remembering

that with Kafka when you have Kafka

Kafka has a couple pieces to it when you

are kind of loading data into Kafka

right the big one is it has some sort of

server bootstrap server so this is going

to be like where Kafka this is like the

URL that Kafka is going to accept the

event at and then kof cook also has a

topic and you can think of topics are

kind of like you can kind of think of

them as kind of like a table they're

like the table of Kafka where like you

have the ability to accept data and put

it into a spot so this is uh when when a

producer connects to kofka that's what

we're going to be doing here with this

Kafka producer we are going to be

connecting to our server on our Kafka

server on Local Host

9092 this is kofka red panda simulates

kofka so we we're able to do all this

local most of the time like in like an

actual like data engineering environment

this is something that would be spun up

in the cloud probably with a service

like something like confluent or you

know there's five million different ways

that you can spin up Kafka in the cloud

but this is going to be the big thing

and uh another thing here

is when you send an event to

kfka it has to be serialized in some way

where because uh you can send like

objects to kfka but it needs to be

serialized into a format that can be

written to disk um and in this case

we're doing just a very basic Json

serializer the reason why we need to do

this

is some data

types uh between Python and kofka and

Json and all the like that the you have

to have a an interchange format between

systems so the way that python

represents data and the way that Json

represents data and the way that uh you

know another language like JavaScript or

typescript or whatever other language

you're trying to work with they all have

different data types and different ways

of representing things and we need to

use a standard interchange format in

order to push events onto kofka so that

then we can essentially read them from

any other language the most common

option to do this is going to be Json

with that being said there are other

options out there like Thrift and Proto

buff and there's a bunch of other

options out there as well that you could

definitely look into Json is great in

the fact that it's

uh um it's very easy to set up uh but

like it's also not great in that like it

is the biggest and it is the it takes up

the most space and uh this is where if

you use something like Thrift or Pro

protuff that would be a great thing that

you could uh look into if you want to

like take these labs to the next level

so and that's another way that you can

change this value serializer here so

anyways let's go ahead and actually uh

send some data to Kafka that's uh

probably something that y'all are

interested in so we have all this

running I'm just going to open a new

window so we have a new window here and

then so in this case we're just GNA say

Python 3 uh SRC producers

producer. and then this is just going to

dump hundreds and hundreds of data this

just dumping all sorts of data to uh uh

to kofka and you'll notice uh when I ran

that it is over here we had a response

from uh from red panda that's uh you can

see it here where it's like hey like

we're actually creating a new segment uh

of data for this test topic and you can

kind of see uh like the response you

should be able to see this in the logs

if assuming that you're not running the

docker in detached mode so we know that

we know that uh the data got accepted by

uh red panda here and that's going to

allow us to uh kind of move forward with

the next step in this process which is

going to be

um we're going to be going back over to

uh our jobs so we have have a couple

jobs here that we're going to be working

with we're going to be mostly working

with this uh start job.pay

uh the two jobs the two Flink jobs that

we're going to work with today are start

job.pay and aggregation job.pay these

are going to be the two um files that

are going to kind of really kind of show

how all of these things uh work together

so let's see if that actually finished I

think it did there's the other tab okay

cool did we send huh we just sent an

integer and a time stamp nothing nothing

fancy nothing fancy here like we have uh

like there's another one here that we're

working with like we have two different

types of jobs here that we're working

with we're starting with something very

very straightforward and very simple

just to kind of really get people uh

aware of how all of these things work

because we're going to be getting into

water marking and uh a lot of other

things here as well and we're going to

we're going to want to send other other

stuff here but we now have uh our data

uh we should have a hundred or we should

have a thousand events in the data set

here that or in the kfka Q that are

waiting to be processed

so how do you do that how do you

actually like connect to kofka and

connect to all of these things so with

Flink so we're using piie Flink here um

and this allows us to actually process

all of the data using Python and uh with

Flink uh there are two concepts that you

really want to be thinking about you

have a concept called a source and you

have a concept called a sync a source is

things that you read from a sync is a

place that you dump to and uh so when we

want to read from Kafka what we're going

to be doing is uh connecting and then

you have to you have to put a couple

different uh

um uh parameters when you're creating a

table here in pink you'll notice uh

let's let's go over each one of these

because I think they're all uh super

important so this first one connector

okay this can be uh there's so many

different things that this can be like

it can be Kafka it could be like an RSS

feed it could be a rest API it could be

uh a web socket like Flink can literally

connect to like everything this is

something I think a lot of people have a

misconception about with Flink is that

they think it's like very married to

kofka and its most powerful use cases

are

definitely uh like from Kafka but Flink

can be used as a realtime integration

tool with other apis and a lot of times

that Flink can be a a synthesizer

between like Kafka and a rest API and

something else like you can join all of

this data together as well um next thing

you have is uh you have your bootstrap

servers so this is just going to be our

red panda address uh

here um if you have

multiple uh it's very common that you

have like redundant uh bootstrap servers

when you're working in the cloud and so

like in that case like you would you

just do a comma separated list where

it'd be like red panda one colon it' be

like 9093 or something like that right

you'd have like you'd have another URL

like and then you just do a comma

separated list that's what Flink expects

if you uh if it needs to talk with

multiple Brokers uh multiple cofa

Brokers at once uh that's a very common

thing but you need that redundancy in

the cloud if you're trying to have like

very scalable Kafka systems then you

have your your topic this is going to be

you can think of this as like this is

the table that we're reading from in

Kafka uh this was we defined this over

in the other file I just want to make

sure that that is obvious right so when

we did producer. send here we we sent

our topic or we sent to this test topic

here and one of the things that is kind

of wild about Kafka is that like there

isn't really a schema here there isn't a

schema right because like I could send a

completely different I could send a

completely different event with a

completely different schema to the same

topic and it would still work it's so

it's it has a lot less constraints on it

than like a table does in SQL so anyways

that's what the topic does now these two

are very very important

so you have uh in Kafka or when you're

reading from kfka uh kofka uses these

things called offsets offsets keep track

of like how much of the data you have

read so um you can think of it as

there's there's three values that you

can put here and we're going to we're

going to explore two of them we're going

to explore two of them here in just a

second uh there's three values you can

put here you can put earliest Offset you

can put latest Offset you can put

earliest offset and latest

offset earliest offset what that's going

to do is when you kick up Flink it's

just going to read everything that's in

kofka whatever you have all the way back

to the beginning of however whatever

data you have in kfka it's GNA read all

of

it uh if you use latest offset what it

will do is it will kick up and there'll

be a Tim stamp of when Flink starts and

it will only process new data that's

coming in after the job starts so that

is a big difference like what like if

you use earliest the earliest is very

often used like when you're like you

know like like back filling or like

restating data like you're kind of using

Flink you're using uh Flink Link in a a

way where you're not processing data in

real time you're actually processing

data with a delay because you're just

processing the data that's been sitting

in kofka for a while whereas latest is

the more often the time like how you're

going to have Flink be working with uh

like the more realtime data that's

coming in as like you know people are

clicking buttons on your website or

whatever event feed you're processing

there is a third option here and this is

where uh like because Kafka like

sometimes what if you want to like read

in not everything in Kafka but not just

the most latest right so a third option

here is you can put in a timestamp of

like I want to read everything from

March 2nd 2025 at 8:05 PM because that's

when I you know that's when uh my

failures started so that's going to be

your three choices here this is this

dramatically changes the behavior and

how much data your job is going to be

processing and then last but definitely

not least here is going to be the format

you have to specify what format uh you

are working with so here you can use

Json you can use uh there's also like

CSV there there's a lot of different

things that you could potentially read

in here like as your format so that's

another thing to like explore uh to to

see how you can make Kafka more

efficient

but this is our source so this is how

we're going to set up a source

interestingly enough the name of this

table doesn't matter that much doesn't

like because this is just what Flink is

calling this table like so this this

this table only exist the table name

here only exists within Flink when it's

running this table name does not exist

anywhere

else um so a quick question yeah so

first of all just to understand the up

so Kafka is U the how to say is the

communication Channel where we send so

there is a thing that sends messages to

Kafka right so the the message stored in

Kafka in our case it's red panda but

could be Kafka or something else that

implements the Kafka interface so we

sent the messages there and then um so

this is the communication Channel and

then there are things that can read from

this communication channel so for

example it's ksql

um and Flink right so Flink can read

from there right yeah and the way Flink

reads um so it looks looks at the at

this stream of data and okay what have I

already processed so far and what is the

new right and this is the offsets that

you mentioned yep and I was wondering um

so we start fling for the first time

right and then there is this stream from

topic so it processes the entire

think everything all the events that are

in this stream in this topic right what

if something happens and our job dies

like the process dies and then we start

it again does it necessarily process the

entire thing again or how does it work

that's a that's a great question so um

it when in terms of that like so if you

started off with earliest offset this is

just for um startup when you kick off

the job so if it and restarts then it's

going to be using uh another thing

called you can enable a thing called

checkpointing so that's a little bit

further down here checkpointing so what

this does is it will it will re it will

read like so this will take a snapshot

of the the state of the job every this

is set up to have it a snapshot every 10

seconds so you can have a snapshot of

the state of the job at that moment in

time so it knows how far it has read uh

when it fails so when it when you when

you restart the job or when you start it

up again it won't read from the earliest

offset it's going to read from whatever

the last checkpointing the last

checkpoint was and that's a very

important thing to enable in your jobs

for resilience purposes is like if

something fails you want to have a

checkpoint or like if you need to

redeploy the job right or like you or

you're you're updating something in the

job you need to definitely have a check

pointing enabled so that you can get uh

like so that when when a when a failure

does happen you're not starting from the

very beginning again right or like the

other thing that can be bad is like

you're not starting from the beginning

but you are uh or because if you use

latest that you have a different problem

which is you uh you skip data like you

miss data that like uh when you redeploy

and uh these things have some

interesting trade-offs like because

sometimes like that is what you need to

do because of like how things process

and and that's where there's like those

different architectures right because

you have like Lambda and Kappa

architecture where Lambda architecture

kind of like does it just reads Kafka in

a batch where this is reading Kafka as

things are coming in and that's where

there's there's interesting trade-offs

there that is definitely another thing I

would definitely uh encourage everyone

listening this to read up on is like the

differences between those two because

streaming is by its very nature kind of

a little bit brittle in that way where

like you have to when when things are

set up like and um bouncing back from

failure can be a little bit more

difficult for

sure um but yeah does that answer your

question yeah it does yeah it does so

when Flink starts for the first time it

creates this table but when it for some

reason fails and starts again the table

already exists so then it keeps the

checkpoint somewhere in memory or

somewhere on the disc I guess so then it

realizes okay the table exists this is

the checkpoint from this moment I need

to start yep and like where the

processing needs to happen right and

like and it gets complicated and this is

where Flink is really amazing actually

because uh a lot of times it might be

failing in the middle of a window right

and then it will have not it doesn't

just keep track of these offsets it will

also kind of serialize to dis like the

the the open Windows because there's

going to be because if you say you're

looking at like a 5 minute window and

then the job fails 2 minutes deep then

like uh there's going to be data there

that is that has been processed after

the offset but it's also going to have

that data also serialized to disk right

and that's going to be the other piece

of this checkpointing that's why

checkpointing is you want to uh it has

an interesting balancing act right it's

like you don't want to checkpoint every

one second or whatever because that's

going to be very expensive it has like a

uh it has an interesting trade of like

resilience versus efficiency that uh

that you want to kind of play with

especially at scale like with these play

examples it's hard to like illustrate

this but like that is definitely a piece

of this for

sure um okay so when we create this

Source right let's let's go down to the

the actual job here to maybe understand

like what's going on so this is going to

be our actual job you'll see um in our

you know our main method here is log

processing it's this log processing

function so with uh when when Flink

starts it sets up an execution

environment right and then you have uh

the this is the environment that like

allows Flink to know what's going on and

where where the what the state is and

then we are enabling checkpointing like

we just talked about then uh then one of

the things that's really interesting is

uh Flink actually has a batch mode right

so when when we are setting up our

environment settings uh you can actually

change this you can actually there's

like in batch there's like in batch mode

here as well which allows Flink to kind

of just

process it it won't it makes it so Flink

doesn't the job doesn't stick around it

will just process a chunk of data and

then it will stop it'll kind of treat it

like more like an airflow or like a like

kind of a a more standard batch process

whereas like in streaming mode the job

will just sit there and keep listening

it'll keep listening for more data and

more data so then we have our table

environment this is where we are

actually going to be creating tables and

looking at uh different sources and

syncs and this is where Flink is going

to start to understand these kind of

things so this is where we actually

create those tables right or create

those sources so you'll see here we have

that

Event Source we created amazing so

you'll notice here we have a watermark

for this um for this Source um for this

first job since this first job is just a

pass through all it's doing is it's it's

pulling the data off of kofka and

immediately writing it to postgress

water marking doesn't do anything

watermarking only matters when you're

doing Windows when you're actually like

and a window you can think of a window

in uh Flink

as uh it's very similar to like running

like group by like a group by statement

in SQL and so uh but it's more

complicated because one of the things

that you got to remember uh between

batch and streaming is some of the data

that you're grouping on doesn't exist

yet or some of the data because it is

coming in and so a lot of times and and

and it's even more complicated than that

because some of the data that you're

grouping on might be out of order

because the data does not arrive in the

right order and so that's where when you

set a watermark this the the main thing

Watermark does is it it specifies the

tolerance for outof order events so in

this case uh we are setting that to 15

seconds so if you have any events when

you run your group buy or your window if

you have any events that are out of

order within 15 seconds it will fix it

will automatically fix that problem

because it's going to wait so

essentially this this adds latency to

your processing but it will wait in

extra 15 seconds to make sure that it's

captured any incoming events that might

be out of order so uh that's what

watermarking is for uh and uh that's the

the big thing and you can the cool thing

about water marking is you can do it

based on a couple different things you

can do it Based on data that's or you

can B do it based on time stamps in the

data or you can also do it based on time

stamps from kofka like because there's

two events there right it can be the the

event time that of when the event

happened or the event time of when Kafka

accepted that event which can be two

separate times because of network

problems or uh you know like say you

click a button on your Android phone and

then like you go through a tunnel and

that event doesn't get sent until after

you leave the tunnel and you reconnect

to the internet

that's going to be uh and and so that's

uh that's where this watermarking is a

very powerful way to capture that but

again this has uh trade-offs because uh

from one side you're like I don't want

any out of order events but then it's

like but we're processing in in real

time so like you have to there's a trade

right a trade of like how like how much

how much guarantees do you want on your

orderedness versus how much latency do

you want to add to your job

so anyways we create our Kafka Source

then we want to create our postris sync

so let's just go look at that function

real quick this function is another way

that we can create connectors so and so

in this case you saw in that last

example we used connector Kafka this

connector is going to be

jdbc and then we have all of our um

postgress uh table is going to be table

is this processed events which is that

same name this name does need to match

the name that we put in uh our table

right this like when we said like know

select star from processed events this

this table these need a match right so

then we have our columns and this is our

just connector example so this is going

to allow Flink to run insert queries

into postgress in real

time so that is our uh our sync so now

this allows us to have t

to then play with and we can run SQL on

so in this case uh what we're going to

do is a very simple insert into

statement and uh then we have then we

call weight here so the weight here is

essentially uh waiting for new data to

come in that's literally what this is

doing and what uh you'll see here is we

have our source table this is going to

be Kafka and our sync is going to be our

postgress sync and then we we just have

our test data which is just it's like an

integer it's an integer 1 to 10 and then

we have our event Tim stamp which we put

in from our producer which is literally

just like an event

timestamp

so now y'all are probably like well how

the hell do we like get this job to run

right that's a that's probably the

that's the next step of this journey so

in the um in the code here we have uh

let me go back to code in the code we

have this make file so you can either

use make or Docker compose I'll use

Docker compose for this but like you can

literally use we have make job which

allows you to actually just uh it will

run this big old Docker compos um

function and you'll notice here we're

actually calling the job manager and

this job manager is going to be calling

Flink to run this uh uh this python file

so Flink is a Java library right so

we've in order to get this to run with

python there's a lot of extra um little

things that you got to do that's why you

have to add this dot this Dash pie here

to tell it like hey hey Flink this is

not Java this is python so you gotta run

it like Python and then we're adding uh

uh we're adding our source files that's

what this is this Pi files here is going

to be adding the actual source files and

the reason why it's this folder is

because uh in our Docker compose we copy

our source folder here into uh into that

so let's go ahead and um grab this guy

then in here we can go ahead and run our

Docker

compose uh function

here and this should uh kick it up okay

there we go so you see how that like

it's like whoa whoa whoa whoa It's like

uh our um our job manager was able to

pick it up right and uh let's go back

here so see now we have job has been

submitted with job ID blah blah blah

blah blah right so if we go back now

we'll see uh we should have a job here

yeah cool there we go so you see this

job is running and uh it's gonna uh so

one of the things that's interesting is

uh this is just like a a pass through

job where it's just Tak data and then

dumping it right so it a lot of the the

metrics that you're going to see here

are actually all going to just stay as

zeros because blink is never actually

holding on to any of the data because

it's just running right through it

doesn't actually ever like aggregate or

hold on to any data that's why like when

you have a simple job like this you'll

notice like a lot of these like bytes

sent bytes received are always going to

stay as zeros um even though the job is

running and how do we know that the job

is running because if we go to postgress

and we query it we have data right we

have data see there's all sorts of data

here right we have uh we were like this

actually Flink actually dumped the data

in here that we would expect and so and

we can see there should be like roughly

speaking a thousand rows of data right

or 990 rows of data Maybe I I did the

producer not act everything that's very

interesting oh it's because it's because

we start at 10 okay it does have all the

data like it actually has all the data

so one of the things I want to show here

though is

like this job is listening in real time

so and the way that we can actually see

that is one second let me go to that

uh uh that file okay so in here we can

see uh what we got oh yeah SRC producers

producer I'm just going to dump another

thousand uh events into into Kafka and

we're going to see that like over here

you see every time I run this query this

count query you see how it's just going

up and up and up in real time like we

are just immediately dumping the data

into uh from Kafka into postgress and

Flink is just listening just waiting

listening listening listening so this is

uh like definitely pulling in all of the

data in real time exactly as like you

would imagine and this is this is

literally how companies process data in

in in real time for the most part is

they have this Kafka this Flink and then

like it's it's a little less common for

things to actually be dumped to

postgress H versus like a data Lake like

there's an interesting technology called

table flow that's it's coming out that

is really cool that allows uh data to

just flow immediately into Iceberg and I

that is going to be like the the future

of stuff so now we'll see we should have

almost 2,000 events yep there we go that

worked worked great so so now what

happens here like if we uh I I want to

show what happens like if we are uh like

what happens

like like some some stumbling blocks

that can happen here right so if we go

ahead and we just like I'm just gonna

kill the job this all right I just I

just killed the the Flink job and this

is going to be a beautiful stumbling

block that y'all uh like I I want y'all

to be very aware of when you're working

with this stuff so then I'm just going

to start it up

again

right

so let's see the the checkpointing here

should give us what we're looking for

and if the checkpointing is working then

we shouldn't have any duplicates right

but we do we do have our duplicates here

right and uh the reason for that right

is because this job got completely

removed from the job manager right it

got completely uh it got because like

when I killed it here it got completely

removed so this is where the

checkpointing is a very you got to be

very careful right about like how things

are working there right so we go back

into here you'll notice with our running

jobs right we had that job that ran for

four minutes but now this is a separate

job that is uh a part of it right so um

the the the checkpointing

is is is only in for a specific job that

you're running from a specific entry

point so that's a a very important

caveat and you'll see I just created a

bunch of duplicates right it was just

immediately added it just doubled up the

data so you want to be careful uh with

that stuff like this is where um when

you're setting your offsets like if

you're literally like killing all of

your jobs like that then it's better to

uh be care when you're when you're

redeploying the job it's better to use a

time stamp here for this this this these

these pieces here instead of earliest

because earliest is just going to pull

in everything um but

like these checkpoints here when there's

failures and it will bounce back that

will that's fine so let's go ahead and

kill this other job here this you'll see

I actually didn't even kill it you see

how the they're they're both still

running yeah go you got something Alexi

yeah I was just thinking so the tables

we create they are per job right so each

these jobs have uh has their own

tables um for

uh yeah like especially for the source

like uh the the syn here is going to be

the same though right because of the

fact that it's all postgress

right yeah so when we Define when we do

uh when we Define the Flink tables right

so when we say how we want to process

them each job has its own right and each

job has it own um um checkpoint correct

yeah its own checkpoint exactly and so

now what is happening is there there are

two consumers that is pulling from the

same stream and now if you execute this

job again we will have double the that

amount of data yeah and that like

because it's not like something that

Flink is not super aware of uh like how

many other jobs in this space are

running it doesn't understand that right

it's this is one of the areas where it

is kind of like a little bit dumb right

it's a little bit like it but in a in a

good way this is actually also a good

thing because having that other layer of

overhead would be a very complex

platform but like yeah all of those all

the checkpointing things are

encapsulated into one job so uh that

that's where it's important to be able

to like so if we cancel this job one of

the things that you can do is uh you'll

see here you should be able to can you

do it in here this it's usually a way

that you can you can I think it's oh I

think you have to do it from the CLI but

what you can do is you can restart the

job with uh with new code if say you

need to make a change or something like

that that is going to be how you do it

as opposed to kicking off a new job

because then if you restart the job you

can pull from these see these

checkpoints that it's uh uh creating and

that's going to be the the better way to

kind of like recover from uh some of

these like failures and some of these um

issues right so I'm going to uh cancel

this one too just to get us into another

space here so one of the things I want

to show is what happens if we change

this let's just change this guy to um

we're going to change this to

latest

so now if we go here here and we uh run

the run the job manager

here okay

so you'll see when we run latest and the

job picks up we are not adding more data

right we still have that 3900 rows right

and so what what I want to do is in the

producer I'm just going to add like

literally one one row of data just just

going to just add we're going to sneak

in

one okay so I literally added one row of

data so we should see literally just one

more row of data here so uh because it's

only it's essentially listening on at

the end of the queue it's only looking

for the very very

last like the most recent data only data

that shows

up after we start the job so that's

going to be uh the other way that you

can do things like like this is where it

comes back to like how you recover from

failures here also just depends a lot on

like how much you value the completeness

versus the latency versus all there

there's a lot of different tradeoffs

when it comes to those things like of

like how you want to recover from

failures but like a lot of times that's

where latest is really nice like if you

just can throw away the data that you're

missing there but and then that's so how

it works a lot in like in big Tech is

they use latest here and if there's a

failure they just like use latest and

then they use Lambda they use the batch

mode to process like the gap of missing

data for that space so that like you can

clean it up that way but there's like

this is definitely a space where I want

to there's best practices need to be

really like nailed to the ground here on

like what the right way to do stuff is

so anyway anyway that

is the like kind of the basic basic job

this is literally like what I just

explained over the last 40 minutes is

how to how to run insert into select

star with link it's uh not too crazy

it's uh there's a lot of pieces a lot of

moving parts to this but uh it's it's

pretty straightforward so but what if

you want to do like a group buy what if

you want to do more what if there's uh

because obviously there's definitely

more to this than just uh like if

analytics was just select star like we

we would all be done we'd be cooked by

chat GPT by now but uh so let's let's

jump into this other job real quick to

kind of see what's going on here

so this job uh is going to require

another um we're going to need to do

another create table uh in postgress so

that we can uh look at this data as it's

coming in so let's go ahead and uh

create this table real quick so we're

going to go in here we're going to say

create table processed events aggregated

and then we have our event hour this

case

say event hour and this is a time stamp

and then we have our numb

hits it's a big

in

cool there we go that works great so

that is going to give us our table that

we can then actually run with this job

uh you might notice the um the source

here is quite literally exactly the same

right it's literally the same uh this is

literally copy and pasted from the other

job

um but you'll notice here like we

actually have uh there's a little bit

more um aggregation logic here

see here's a here's hopefully some of

y'all data Engineers would know what

this is about like this group buy right

like group buy is here right we have

select that's one of the cool things

about py link is that like you can get

it to look some of y'all might actually

look at this and might be thinking like

data frames like pie spark it looks kind

of like that but also not there's uh

there's a lot of other things going on

here that I think are important to think

about but Let's uh let's just go from

the go from the top here one more time

to kind of talk about what what's

happening here right so another thing

that Flink allows you to do is it allows

you oh this should be this is a little

buggy this should be I'll fix that code

this should be every 10 seconds not

every 10 milliseconds every 10

milliseconds is a little excessive so

um this uh parallelism so Flink also is

very very par

right like and parallelism in Flink uh

is going to be based on the key of the

data so depending on what you end up

grouping on that's going to be uh your

the the parallelism that you're looking

at right

so for example here right we have our um

tum we're creating a tumble window

that's what this is going to be doing

which is going to be essentially just

creating little one minute windows that

we are going to be looking at at our um

events as they're aggregated and they're

coming in and then this would allow us

to process like we can we can we can run

three jobs in parallel here because they

the number of one minute Windows here

that could be open at the same time uh

is more than one it's

actually this is an interesting uh

problem here so it's like okay if we

have a one minute window how many one

minute windows can be open at the same

time well this depends on the watermark

of this right so if we go back up here

we have our

Watermark here which is going to be a

15sec interval so if we have a one

minute window and we have a 15sec

interval that means that this

parallelism of three is not really going

to do very much right we can do two we

can do two because if you think about it

from like a a time stamp perspective so

say say we're on the 50th second of a

minute then uh our Watermark will have a

15 second overlap there right so then

there the that 50th or that minute and

then the the next minute will be open

right the like or or or we're 10 let me

rephrase that when we are 10 seconds

deep into a the next minute the previous

minute has not closed yet because we

need to wait 15 seconds for that minute

for that uh to close and um that is

going to allow us to have a parallelism

of two um if we grouped by more things

right we could do that and we actually

do have more groups here right because

we actually have this uh test data and

if you remember from our producer here

that test data is literally um the

cardinality here is very high like it's

there's like thousands we we we we

pumped in the numbers 10 to a thousand

so

um the amount of cardinality here that

Flink can actually pull from this will

group The these two things together so

three three would work here but if we

were just grouping on uh the window it

would not but since we're grouping I I

forgot about that forgot that we're

grouping on both

so because it's just like with spark

like when you're grouping on things like

uh it will hash that set and then it

will it will distribute that uh key to

uh one of your executors and it's very

very similar to spark in that way and

that allows for different levels of

parallelism when you're doing these kind

of uh when you're doing these Group by

Transformations and so we will keep this

at three right now because that will

allow us to kind of show like how Flink

uh will scale up and how Flink can

process things in parallel because

that's the whole reason we do big data

right is the whole concept of like

distributed compute and uh this these

these settings scale up to terabytes and

even pedabytes of data and you can do

all this in real time so anyways that is

essentially what I have for uh kind of

the setup so let's go ahead and uh quick

question so with your example when I'm

in a car in a tunnel and then I click a

button not that I should be doing this

in a car in a tunnel but like like okay

imagine that there is an event generated

in a tunnel right yeah and then the

tunnel is like I don't know it takes 5

minutes but our uh window is 1 minute so

after we leave the tunnel the event is

delayed by five minut five minutes so it

means that it will not be included in

our analytics right now or what is going

to happen Okay you you you come like

this is you you present a very very

interesting um

uh example right so what you're talking

about is so there's two types of

lateness right so the first type of

lateness is you know uh I call it like

you know you know when someone's like

one minute late to zoom and you're like

okay they're not even late because

they're just there there's like an

acceptable amount of lateness and that

is going to be you can think of the

watermark as that like amount of

lateness that you're like okay it's fine

like you you you arrived on time right

but if you're talking about something

that's like uh late but it's late Beyond

The Watermark there is um Flink has that

like let me uh let me there's like a see

allowed lateness

Flink so you can set that as well there

is a so a loud lateness is going to be

yeah they it has another so this is

another

um uh value that you can set in Flink

which is like what is

considered uh dramatically too late

right so there's actually two lateness

values here so like in your case maybe

we do set the that allowed lateness

value to 10 minutes or whatever right

then what what happens in that case is

when you're out of the tunnel and your

event gets sent and these are one minute

windows

Flink

will that data will come in and Flink

will actually go back and it it will

like find that old window and it will

create a new window with your with your

data right but that also adds another

record it adds another record and so on

your uh on the other side on your like

on on the like sync side you need a way

to like d duplicate the windows to like

correct for that

that is something that you need to do

like if you use aoud lateness that

that's definitely uh one of those

trade-offs like of like how much allowed

lateness do you want to do and that's

another thing with allowed lateness

Flink has to hold on to all of those

windows on dis so after after Flink like

does its Group by and then it uh and say

the the the one minute completes and

then 15 seconds happen after that then

that window is now closed and that

window can be passed to the sink and

then if uh you create data that triggers

a window like that is closed it will

generate a new window and it will pass

that to the

snc only if that wind only if that time

stamp is within the the threshold of

allowed lateness and and uh and the the

default for allowed lateness is zero but

there are like there are jobs that um do

that and you can also there's there's

also a way that like you can process

this data separately like you can do

side you can you can side output the

late data so it goes somewhere else so

you can like kind of manage the lateness

in like maybe in a batch process later

on or like uh there's a lot of different

ways that you can handle this but like

the I like the the side output is a

really solid way to go for like really

late data which will create an interval

that is the it's the more correct uh

interval like the more it's the actual

correct count of the events but uh it

just arrived later because you were in a

tunnel that would be the I guess that

would be my very like caveat answer to

that question so let me try to summarize

what you said and at least also make

sure I understood what you said so like

with default settings the event would be

just discarded yeah because arrived

lateness is zero right so the way it

works um so events are coming and we

process Flink process them and let's say

our window is 1 minute so we accumulate

data over 1 minute we process them let's

say we do group by uh minute and count

so we are interested in the number of

events in this window so once we have

the number we know okay this is is the

minute I don't know uh right now it's uh

1755 so for this minute we had 10 events

right and then we just at the end of the

interval we just flash it to whatever

Source uh whatever sync we have let's

say it's a postgress database then we

just insert a new record right so this

is what the default Behavior if we allow

late uh lateness right then we would

need to somehow go back and three update

this uh uh the final aggregated value

right because we will have set a new

window right yep let's see okay it will

it will read so what Flink will do if

you put alloud lateness here it h

everything that's within that window of

like the whatever allowed lateness is

like say you do like a 10minute window

all of the all of the windows within

that like time frame will be serialized

dis in Flink as well so it will it will

read whatever the window was like before

it was before the watermark closed it

will read that window uh and then it

will add your event to the window and

then it will do the new count and the

new aggregation but it does send a brand

new like that's a brand new like event

and a brand new window to your sinks so

yeah so you need to have some logic to

actually um how to say combine these two

windows

right yeah station would be just

overwrite whatever is there cuz the

latest one is almost the the correct

state right but like sometimes would be

I don't know doing a sum or whatever

depending on what exactly we do in our

yeah a very common thing a very common

thing that they do in postgress is uh

like is there's a thing called on

conflict update right where you just you

just pull in the new count right because

it's like you H where instead like when

we created this table here right but we

could put like a primary key on this guy

and then we could put on conflict update

so that we just update the count to what

its actual correct value is that's a

that's a very common way to like handle

this situation but it is it it's it's

it's like the the right way to handle

this does depend on the use case though

yeah you're totally right about that

yeah amazing thank you awesome so let's

go ahead and actually uh run this job I

think that that's probably something

that y'all are interested in doing so uh

let me go ahead and so in this case all

you got to do is change this start job

to um aggregation

job and this will go ahead and kick that

off oh

I in put field

list okay there's a I think there's a

what second There's Something Fishy here

so we have our event Tim

stamp oh I have a oh because I put

window Tim stamp and it's I think it's

event

Watermark yeah this is um should be

event

Watermark that's the that's the issue

query schema event Test data oh sync

schema oh we need to put the the test

data column in there too because we we

are actually grouping on that so so this

needs um test data integer yeah and then

uh we have our yeah we have the column

here as well so oh we got to drop this

guy though okay let me go ahead and do

that

it says a test

[Music]

data perfect okay so now that will give

us our uh that should give us what we

want so now just r one more time here

flink's pretty

good it

like there we go just riding and

silently you know failing it tells you

what the problem is right so it can

analyze the query yeah you can see like

here I'm like oh I'm missing the um I'm

missing that that column right and it's

pretty good like the actual like it it

gives you very similar stuff to like

spark in that way so now like one of the

things I want to show here though is if

we go back to

8081 we should see this there we go so

one of the things that's really cool now

is we actually have have uh like you'll

see like remember when we first did like

that pass through example that I was

talking about now we are actually

holding on to data right and you'll see

like we we actually get like performance

metrics here now of like how much data

we're receiving and like where it's

coming from and uh like we have our

records and it's all kind of there right

so this is uh this is working pretty

well now um but we should be able to

should be able to see some data here

like

like okay so I think it hasn't that that

doesn't make sense that is that

uh Second we have the log aggregation

then this is going to be from path

execute insert aggregated table okay

that that should be there so we have our

aggregated tables here has our test data

numb hits okay that like it might take a

minute oh it's because I think it's

latest is it is it is it actually

reading in no okay no it's earliest

should

be

that wait a minute that should work then

like is that like for some reason not

actually oh there there's probably a

failure in the um in the insert or

something let's go into that can we go

to the

exceptions let's go running jobs events

exceptions exception okay that's not is

this

one it says that it's just records sent

records

received and then uh does this have

uh watermarks are only if event time is

used there should be uh but this this

does

have maybe like you said we just need to

wait uh I mean it should only like it

should only take like one minute though

right and like yeah because like it

would be this okay there's there's

something here that is a little bit off

I think it's cuz like okay so we have

event Watermark event

timestamp for event Watermark as event

Watermark that should be this should be

our Watermark because that like I think

that that it's I know that the group

here is a little off I think that's what

it is like is it this because this is

our tumble window on this it is it is

reading the tumble window for sure

that's super weird that it's like

actually because we have our timeline do

have it okay checkpoints are actually

okay what's actually okay the one way to

test test this is like let's like load

some data here just like see if that uh

causes it to um because okay it picked

it definitely picked up that next uh

that next data and then this should

potentially uh dump out

another row like but is there there's

nothing else in here that I'm doing

differently right that that's super

weird okay because this should be

grouping here like on okay so we're

creating our window and then we are

grouping on that window but there should

be like a watermark thing here uh one

second let me uh let me actually throw

on like a thousand records again because

this thing should turn red it should

turn red whenever we like dump a bunch

of data like

see that's

like okay so it is it is picking up the

picking up the records here like maybe

it's the thing that we need to wait on I

don't think so I think it's not actually

picking it up usually this stuff's a

little bit faster like it's

um because we are we only doing a 15

second Watermark right and so uh one

second I have a I have another example

of this I was like very close

uh I have the one second how did I do it

here one second there's

a watermark for

four water time stamp okay we got the

time stamp there and then this is window

time stamp call call

call okay that that is that is it okay

what the

hell

um

okay yeah it's definitely not a loading

in the data there that's like it should

be picking up the watermark there though

it's uh but it's not for some reason

okay let me go back and see one second

that's not the one okay go back to pie

charm Zoom cap okay so aggregation job

is there something else I'm missing here

because we have our group by window

Group by and then we have our column

execute

insert aggregated table that uh and then

this has our aggregated syn here is that

[Music]

and and then this is just not okay I

want to check one more time here and

then y it's

not it's not actually loading into it

that's super strange okay

because okay because that is right and

then we are on column event Watermark

and that is our event Watermark up here

so the one thing oh is this different

though is this three this three might be

wrong what in the start job it's oh it

is three okay that's not it either then

that's because that's like sometimes

it's like the this is converting an

integer or it's converting like a epic

to a time stamp that's super strange

that should have worked but okay anyways

let me uh like kind of explain what's

going on like it's for some reason it's

not picking up on the water mark That's

the why uh this is essentially not

sending data anywhere that's what's

literally going on like

CU there's just no exceptions

though it's very

interesting okay let me think here

like okay

like these windows I know that there's a

small thing here there's some very small

thing on this Watermark that is

uh not uh like it's not pulling it in or

something like that it's not uh like

grouping on the right thing I I swear I

had this working before um yeah maybe do

fix it later and then yeah yeah this

will be fixed this will definitely be

fixed in the um like by the time um like

we have we publish all this code but um

anyways I wanted to go o one of the

other things I wanted to go over here

with like with because we have a like

with the homework we're going to be

working more with like taxi data and

there's going to be a lot more columns

that you're going to be working with

so there's many types of Windows that

you can work with right so this is the

most basic type of window right is you

have a tumble window which is very

simple it's very like okay we're going

to cut up our our our job into uh um one

minute segments and that's just how it

is then you have uh you have a sliding

window which is a little bit different

because when you think of like a one

minute window a lot of people think of

like uh like the first minute of the

hour but there's actually another one

minute window because you could think of

like 30 seconds 30 seconds of one minute

to 30 seconds of another minute like

that's also one minute but it's a

different one minute and it's like half

of one minute and half of another one

minute and so you have like a so you can

have like a sliding window right that's

like got we have that in the

um uh so sliding window link this is a

is that have that

so oh I think that's what I'm missing I

think it's uh yeah I think I'm missing

this key by I honestly think that that's

what it is from because then you have

key by. window so in this case that's

literally what's missing

here so it's Key by and then call and

then this is test

data I'm pretty sure that should

uh because

then because now this is a keyed

stream I want see if that works actually

see if that like actually fix our

problem but um anyways back to like

sliding Windows versus uh okay tumbling

Windows well that we'll let that run but

like so tumbling windows are very

straightforward they just cut it up into

like very obvious things this if you

live in a batch World a tumbling window

is very similar to like the batch world

then you have a sliding window which is

where like I was talking about before

like that like you can have one minute

but you can take the slice of one minute

from different points and like so a lot

of these windows kind of overlap so um

that can be another way to

um do things right is you have your

overlapping

windows and then uh this is my favorite

this like for Flink this is and this

will be part of the homework here is you

actually have a session window so a

session window is great because the size

of the

session is determined by how many

continuous events happen within a period

of time so like there like if there

hasn't been any events after a certain

amount of time time then that window is

closed and this is a very powerful thing

when analyzing like user Behavior

because you can think of like when I log

in I log into an app and I you know

click a bunch of buttons and then I

leave but maybe I only leave for two

minutes and then I come back that's

still technically like the same session

but that's where like when you you you

you determine this session Gap and

you'll notice like we have like a like

there's going to be this like with gap

here that you want to put in there's a a

way to do things like where you have a

you you have a static Gap and apparently

they have a dynamic Gap now I wonder

what that's about that's oh it uh it's

something that you can actually Define

yourself and on like how to determine if

what what the Gap should be that's

interesting uh most of the time like at

least when I've worked with Flink the

the actual way that I've done things is

with this um with this static Gap this

is going to be the uh way to think about

it so it's like the so the window

doesn't close at like a specified time

the window closes after a specified

amount of inactivity so after there's

been 10 minutes of no inactivity or 10

minutes of inactivity where there's been

no new events that is where you get the

that's where it actually get the data

right that's actually where the um I'm

try to say here that's where the uh then

the window will close and it will pass

it to the sink it will pass it to

postgress it will pass it to kofka or

whatever and so this like when I've like

worked with Flink the these three

different types of Windows have

different purposes so like this first

type of window is just like essentially

how to speed up batch so if you use your

uh um tumbling window this is a great

way to speed up batch sliding windows

are very good for op imizing like so if

you want to figure out like your Peak

right your Peak uh um user count or your

Peak growth or your Peak whatever

because you use these overlapping

Windows to find the moment in time where

you have the the highest or lowest

values and this is a good for like Min

maxing sort of thing and then a session

the sessions is very good for like just

grouping user Behavior together so that

you can analyze things in like a group

and you can analyze a set of events as

like a session just like what it talks

about here like sessionization is super

powerful and um like those are going to

be those are essentially the three types

of Windows I want to see real quick if

that actually uh if that if if if me

missing that key by was the um was the

actual uh oh no that

was oh the the current table has no

column name Key by key

is it keyed by did

I like go back

here no it says it's do Key by that's

right okay

um from path table. Key by column test

data source

tape okay so I want to just try this one

more time and if this doesn't work I'm

giving up this okay so Key by does not

work because columns available event

Watermark because

that that's super weird that like should

work is it after the window is that what

it is is it like because okay so that

goes and then that goes and then that

interesting anyways I will

uh y okay so kbi is not like Flink is

lying to me like this the input here is

like totally not like for some reason

this is this ke I think is not working

the way I would expect it to but um I

think that's pretty much uh what I had

to show for um the this this lab and

this session um do do we have uh do we

have time for like Q&A or an opening

stuff like for that for that Alexi or

yeah yeah for sure I I I I I definitely

have time um I I I I know that I I

covered an unbelievable amount of

information in the last like 70 minutes

so yeah definitely

MH so um apart from Flink uh we have

other consumers right so and then maybe

let's take a step what I saw in the live

chat is um the question um let me just

read it what exactly does fling do why

can't we just use Kafka to read and

store so I assume this question so I

assume the question that we have here

that in Kafka in the Kafka python client

we have produced producers and consumers

right so here we saw an example of a

producer this is when we put something

to Kafka and consumer is something that

it's takes things from Kafka and

processes them right and this is a very

lowlevel thing MH when we just use

the the library from Kafka to process

this um so what's the Flink uh role here

uh what are the other options that's a

great question I mean I love that

question I actually in you know in my

company I just use the consumer API 100%

that's all I use kofka my company like

for uh grading jobs like I use it for

all sorts of random stuff but like uh

like so there's going to be some cases

where flink's going to be better like if

you're doing windowing you're doing this

group buying and watermarking and a

lateness like you can do that with a

consumer API go ahead and manage it

yourself though like good good luck like

it's like like if you're trying to

figure out how to like create these new

windows that uh where like someone goes

through a tunnel and like you miss their

data for five minutes and then they come

back like and then serializing that

stuff and the checkpointing and the

restarting of the job where it can

recover uh all of that stuff like is

where Flink is going to like just it's

gonna make Kafka the Kafka consumer apis

look very very uh like annoying to work

with uh I would say that those are the

main things sessionization like so so to

summarize it's going to be uh job

recovery uh late late arriving data and

windowing those three things are uh the

three things that Flink have going for

it like some people would argue that

there's one more which is going to be

around like scalability is that like

parallelism side of things where it's

like Flink it's a lot easier to manage

like the memory of Flink and the

parallelism of Flink than it is to

manage the the memory and parallelism of

just a gen like kofka consumer uh it's

similar to being like uh like is kind of

asking the question like why use spark

when you can just use pandas right and

which is yeah you can use pandas 100% or

polers right you can use polers and

pandas but like those Frameworks just

are not going to work like at the higher

end of scale and in a distributed way

and the stuff like

that but also um correct me if I'm wrong

but yeah with the link with the sorry

with the cap client we need to keep

track of the checkpoints ourselves of

the latest process time stamp so we need

to save it somewhere right so we need I

don't know be a file or a database but

we have to manage it ourselves here we

don't need to do it because fleing keeps

the state for us that's one and then

another thing is in your first example

when all we did is just the record

arrives and we put it in a database

super simple thing but we did not need

to actually write the insert code so

because we used the uh implemented code

that goes that um uses postgress as a

sync which means that all the code for

writing to postgress is already written

we don't need to uh sorry have like a

separate step or like a separate thing

going like or like having to like yeah

it has like a lot of those good

connectors like the jdbc connectors are

really nice right and you don't have to

like bust out what pyop pg2 or something

like that to like do it right yeah for

sure my screen just went black I don't

know I have no idea what's happening I

think some

Hardware uh stuff I'm sorry I cannot see

you Zach anymore I can hear you so

that's something yeah that's good um so

what I'm going to do right now is um I

will just continue reading questions

from the live chat hoping that my

laptop will recover and I will not have

to buy a new one yeah right so it

doesn't just fall off a cliff right

yeah so um another question is like what

are the use cases of streaming because

uh for many things we don't necessarily

need streaming right we can process uh

things with a batch mode like maybe we

can process them like the events that

come in mini batches of I don't know

five minutes I don't know if five

minutes is a mini bch but like we can

process events we can let them even if

we we use Kafka we can let them

accumulate and then have a job that we

trigger every 5 minutes that just

everything that is accumulated in Kafka

we just take it process it and save

somewhere we don't necessarily need

streaming but there are cases when we

definitely need streaming when we want

to process super hand within I don't

know one second after it arrives so what

are these cases when do we actually need

streaming that's a great one I think

that uh

so analytic you know most data Engineers

work with analytical data and the number

of use cases for streaming in analytical

data is not very high it's not very high

like uh I just want to talk a little bit

about like uh like what one use case or

two two kind of use cases that worked in

my career so like one was when I worked

at Netflix we were trying to uh detect

uh um when uh an employees laptop got

hacked right and we we wanted to be able

to respond to that in real time so when

you're asking the question should I use

streaming or should I use

batch there should always the the

follow-up question is is something gonna

happen in real time uh on the other side

because it's it's not usually worth it

to give people like full streaming data

just so that an analyst can look at it

and have 100% upto-date data all the

time that's like usually uh that's

what's called over engineering uh but

like if there is for example when I

worked at Netflix where it's like we

detect a threat and then we we actually

push that you we like quarantine that

user's account based on the streaming

data and it's like it's much better to

do that immediately than in five minutes

or 10 minutes that give them a lot less

access a lot more time a lot less time

to do damage right and so uh there there

are some cases like that like like other

examples would be like Uber's like surge

pricing right you would want that in

real time because that's again like a f

five minutes can be a very big

difference between for supply and demand

right there's like it's like if there is

an automated process that will change

something on the other end of your

pipeline streaming is a great choice if

if you're uh if there is no automated

process and it's just a human that is

looking at data then like the that they

need it in real time very low and and

micro batch is going to be easier to

maintain it's easier to maintain like i'

I've found that like uh like I love I

love two different micro batches I love

hourly batches and every 15 minutes I

love those two I find every five minutes

is if you're like working with spark I

find every five minutes to be like a lot

because like just like kicking up spark

and kicking off the job takes like one

minute right it's like and so it like

becomes like the over head of of how

much like the percent of the job that's

dedicated to just startup becomes a lot

higher the smaller and smaller the batch

becomes so there is kind of a sweet spot

there for sure of like how small the

batches should

be okay so basically when we need real

time uh reaction react real time like in

your case it was fraud detection and

then like search pricing probably there

are other scenarios then we definitely

need it otherwise 50 m minutes batches

should probably do right yeah for sure I

and like in my whole career I you know

as was a data engineer for 10 years

right and uh there was literally two two

use cases in 10 years where I actually

needed streaming right and they were

airbnb's surge pricing and uh Netflix

fraud detection and that's it and then

everything else was uh almost everything

was daily batch and then the the the

things that needed to be uh lower

latency were going to be like uh like

Master data like Upstream Master data

that needed to be lower latency because

like that data depended on other data

that depended on other data that

depended on other data so reducing the

latency of that that very Upstream data

set allowed for the downstream pipelines

to work that's what I did I duped

notification events and I actually tried

doing that in streaming but like it uh

an hourly microbatch was a much better

fit and a much more resilient choice

and I guess also when it comes to

engineering complexity maybe for a use

case like that like uh fraud detection

you need an entire team cuz it's uh very

complex but if we talk about bches maybe

just one date engineer is enough to uh

maintain even a couple of bch jobs right

yeah and one other caveat that I have

with streaming that I think is very

important to talk about is like the idea

of like what are the skills on your team

because like streaming is like kind of a

niche skill and if you're on a team of

data Engineers like a lot of times like

you you might be the only one who knows

streaming and so there's a side of this

that like this is where you want to work

with your manager before you implement a

streaming job because there's a side of

it that's like well if you're the only

one who knows streaming and you're the

only one who knows how to troubleshoot

this job then what will happen is you'll

be the only one who's on call and then

you just call all the time and that's

like it's one streaming I I've seen this

happen again and again with like data

engineering who like and they're very

excited and really happy to learn this

because it feels fancy and exciting but

then like uh when the rubber hits the

road and they're like wow like uh I

actually have to now maintain this and

then then it's on them to teach their

team streaming so that they can have a

day off right and that's a yeah I've

seen that happen a bunch that happened

to me in Netflix so I definitely that's

the there's a lot of caveats with like

this technology even though it's very

powerful there are a lot caveats for

sure so what's your opinion on spark

streaming versus Flink streaming

there're oh that's great I love that I

love this question uh I ultimately think

that they are going to converge data

bricks is investing very heavily in

spark streaming uh and uh they have

spark streaming and like Delta live

table those two things together are

ultimately going to get there because

the right now they're not like spark

streaming and uh uh Flink are different

in a very significant way in that like

spark streaming is just extremely small

batches it's just micro batch right

where Spark streaming pulses like every

15 seconds or every 30 seconds right it

does just a very small pulse whereas

Flink is genuine continuous processing

where like the event comes in and it

flows through right it it doesn't like

it it's like the difference between push

architecture and pull architecture we're

spark streaming is still just it's it's

a very very tiny pole architecture

whereas Flink is a push

architecture right um so because we

actually used um spark streaming in the

previous

modules so we interesting oh yeah it's

it's great I love it too

so yeah um so I see a comment from

Michael that um um in the past Zach has

stated his belief that streaming and

batch data Engineers should be separate

specialities what do you think about

this do do you still think this is the

case should we have streaming data

Engineers as a completely separate role

because like if we think about the stack

and things we need to do like they are

pretty different right yeah I mean that

is a great question like and at uh

Netflix at Netflix they are different

titles they actually are so like uh uh

for streaming focused Engineers it's

actually their title is software

engineer comma data whereas for data

Engineers who are more batch and

business focused they they have the data

engineer title so like I I am generally

a fan of that I'm generally a fan of

like the idea that these are separate

roles that they are like actually like

because a streaming job is much more

like owning a server it's more like

owning a website and a server and a rest

API then it is like owning a batch

pipeline or a you know an offline

process like and so yeah for sure that's

like a like I find that like if you are

working in this space that like this is

a great way to like really expand your

technical skills though and it's a great

way for data Engineers to like push

themselves to like really like get more

technical because it's it's difficult

stuff it's definitely like it's a

challenging difficult work for sure

and last question so this one is from me

so I know um from my uh past that when

it comes to scaling Kafka it's difficult

because you have these sharts so you

have like multiple let's say kafa

streams that are under one umbrella and

you select which chart to send your

event by just I don't know hashing on

your ID or whatever so you have 10

sharts and then you have an event you

hash on the ID or Kafka is doing that

and then it selects internally to which

sub stream to send the data right and

then if you want to add an 11th chart

then like it's kind of difficult because

you need to re Shuffle the data right

yeah so how does this situation um how

do you handle the situation like do you

uh when you provision your CFA when you

create your Kafka topic you like over

provision you create I don't know 100

charts hoping for growth or how do you

do because like sometimes during night I

love this I love this question this

question so this question has caveats

right uh okay so part of it is yeah it's

a pain it's a pain to like to to to re

to Rey and to like repartition the data

like repartition Kafka very complicated

right but like so there's there's a

couple ways you can do it with Flink

with Flink you can actually do this

where like uh you uh like you have to

create a new topic right and then you

have you push the essentially push the

old data there and or you you so you end

up creating a new topic that like dumps

the data there and then you have Flink

kind of read out and exhaust the old

topic so that like all the data is

exhausted and um either like by doing

one of two things like you might have a

job that that does the transition for

you where it does the copy it does the

copy from old topic to new topic that

like to do a repartition that way like

it's a it's a very simple job that's

actually like a very that's like 10

lines of code to like actually do that

and then that job runs until the because

the problem is is like then you have all

these producers right so then you have

to like push all of your producers like

you have to push the code change to all

the producers to be like hey send to

this new topic and then uh then that

copies all the data and moves it over

it's better to do that than to um um

over provision like but like I when I

think about it like you want to think

about like uh you do want to be thinking

about growth of like how much data this

is going to consume because doing this

process is not fun it's not fun but also

having a bunch of extra partitions uh

for your Kafka and like spending extra

money in the cloud and like having all

this extra like dead space in your

cluster is also not good so it's like a

it's a very interesting Balancing Act of

those two things but like I would say

that like my perspective is like you

want to uh like over like over provision

like a little bit and then you know

build in room for growth but like even

then like there's a chance that like if

you get a lot more growth than you even

anticipate then at that point you have

to do this migration pattern so that

you're uh so that tofka and Flink can

kind of work together and you can have

more workers right you can have more

workers processing more

data but as I understood uh the number

of charts remains static so we don't uh

do this every day so for example when

during the day we have Peck hours we

have more uh volume of data that we need

to process and during the night we have

less volume so we don't do this every I

don't know 12 hours it's definitely not

definitely not this is the only time so

the only time that you would want to do

this is so Flink actually has a um uh

another metric that you can look at

called back pressure so back pressure is

so if if if your jobs start to get

really back pressured that's when you

know that uh you don't have enough

parallelism in your job and that's where

uh and you'll get signals like the main

thing that will happen is Flink will

start to be a lot slower and like your

your real- time data will become less

and less and less real time and uh and

so and this is something where this is

like a one-time thing or like once a

month or at the very the most frequent

would be once a month it's probably more

like a once a quarter or once a year

thing that you would do and this would

only be for topics that are experiencing

a lot of

growth and pressure is when events are

put in the Stream faster their process

right so then like there is uh okay so

we accumulate some I unprocessed events

yeah yeah where because because if you

only have three partitions and then

there's so much data coming in and Flink

is like I have too much work man I don't

know what to do right yeah for sure

that's exactly what it

is and so I was leading with this

question to another one um maybe we can

briefly discuss it before we wrap it up

so there's uh for Real Time processing

Flink U so for Real Time processing

Kafka is one of the communication

channels as we um called it but there

are others so yeah Ka Kafka is a topic

it means that we send it U so basically

what I want to say is like there are

other things like rabbit mq right yeah

so um that probably could work better

for our situations um do you know uh

where we can learn more about these

things uh like how do we choose so like

should we go with Kafka always or should

we look at Alternatives and how to pick

the right tool for our event D

architecture I love that like I mean

it's interesting because like Kafka is

really designed for scale right Kafka is

really designed for and and I think it

is misused sometimes actually like for

uh certain architectures especially like

because you can think of as like Kafka

is going to it doesn't have the um like

a lot of the same level guarantees that

something like rabbit does because

rabbit is has a lot stronger guarantees

but it doesn't it doesn't scale and

distribute like kfka does that's like

kind of the trade between those two so

like it's it's similar of like when do

you pick like postgress versus Cassandra

right postgress is amazing because you

have one node and it gives you very con

strong guarantees of like hey my data

was sent my data was not sent like it's

it's very it's very consistent it has

that acid kind of compliance to it

whereas Cassandra is like well the data

is going to be updated when it's updated

and like you know and it's kind of it's

you know it's that soft State like that

and so similarly with kofka and

something like rabbit right like rabbit

has a much stronger like you could use

rabbit in a way that like it like kofka

is not very used like in like like if

you have an application that's like

listening to stuff kafka's used a lot

more in like offline jobs but like

rabbit is great especially like if you

have a use case where you want the data

to like show up in a UI and like do an

event or like it has like the the big

connections of all this stuff and like

and also if you know the big the other

big thing is is like you also you pick

rabbit if you know the volume is never

going to be very big right like and by

very big I mean like you know like like

tens or hundreds of gigabytes at least

right like the rabbit can still handle a

lot too right because just like with

post post can handle like terabytes

right but like and sometimes we over

engineer things and that's where R and

and rabbit also has like this ability to

like route stuff so it's it's it's more

than just a broker it also can like push

things in different directions it has

like uh it so if you want data to be

sent and published to certain places

it's it you don't need Flink rabbit can

do that itself too it has like it's like

a a signal sender as well whereas Kafka

just goes in direction right it's just a

giant like fire hose that's pointed in

One Direction whereas rabbit's more of

like a like a traffic uh like a a

traffic router that can like you know

stop this do this move this move this

it's like a lot it has a lot more

complexity to it in that way so which is

a good thing because you can do a lot

more cool stuff with it would you say

then maybe rabbit mq is like for what to

say usual backend engineer software

Engineers rather than data engineers and

data Engineers they more are more likely

to work with Kafka rather than like you

know this messaging cues yeah yeah

exactly uh I'd say rabbit is a lot more

likely to be for application Engineers

yeah for

sure okay well that's it we took a bit

more time but um thanks for taking the

time to answer the questions and taking

time to prepare the uh the materials and

share it share them with us so what we

are going to do right now is we're going

to publish this video uh we are going to

Pish all the materials in the

module 6 uh part of our data engineering

course I hope my laptop is back to life

because right now uh it's just blinking

I do not see you Zach right now every

time I every time I teach Flink I always

have weird stuff like that happening and

you're not even teaching but it's always

I'm teaching Flink so your laptop has

the

problem okay so I keep my fingers cross

that when I turn it off and on again it

works like it usually does um so yeah I

guess that's it um so I I'll just need

to figure out how exactly I stop the

stream

um if I just power off um that should

stop the stream I guess yeah but yeah

have to figure this out so thanks Zach a

lot uh pleasure you thanks everyone for

joining us today so keep an eye on the

announcements we will announce the

homework soon and right now you're still

working on module 5 spark so have fun y

awesome thank you thank so much this has

been amazing have a nice day bye

everyone see

you yeah I'm trying to turn off my

computer right

now

e e

