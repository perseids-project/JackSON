# SparqlModel is hugely flawed.
I was trying to build ActiveRecord for RDF data.
ActiveRecord is built around SQL and its limitations.
SQL and SPARQL/RDF don't have the same limitations.
I'm realizing it's a fundamentally flawed design.
It was a useful experiment though.
JackSON is a better system.
I know that seems flakey of me, but I was still inexperienced when I started SparqlModel.
Let me make my case for JackSON.

# JackSON
It's a database server.
It has a restful API for doing CRUD with JSON on a filesystem and when it's coupled with the JackRDF, its sister project, it will mirror relevant JSON-LD as RDF on a SPARQL queryable endpoint.

In other words it's a hybrid of filesystem served JSON and SPARQL queryable RDF which you can interact with exclusively over HTTP.

This means new applications can be built exclusively with client-side HTML and Javascript.
Revising a data-model is as easy as writing a new JSON-LD template, 
and searching the data is as easy a suffixing a SPARQL query to a URL.
JackSON's design goal is to find the shortest path, in terms of development time, from user input on a web page to SPARQL queryable RDF.

# It's in the air...
One of the authors of the JSON-LD 1.0 W3C recommendation, Gregg Kellogg, who also wrote the JSON-LD to RDF converter used in JackRDF, has outlined [a similar system](http://www.slideshare.net/gkellogg1/jsonld-and-mongodb) that uses MongoDB as the persistent JSON store.  I don't think it's been built or if it has it's not available for public use.

# Code complexity & development time.
Reducing development time is synonymous with reducing complexity.
The time it takes to develop new and reliable tools should be the first priority of any development team, but especially one like ours where turnover is seasonal.

We have lots of bright young people eager to help us, but they all need plenty of structure to work inside to produce anything useful.
If they didn't they wouldn't be in school in the first place :)
If we can build infrastructure with student-developers in mind we will as a side-effect be making our own workflows more efficient.

With only a bit more development on JackSON we can have students building web-applications which can create published data without having to know anything other than HTML, some basic Javascript, and how to issue HTTP requests.

If it's possible for them,
it will be easy for us full-timers.

# RDF exclusively is a bad idea.
Storing application data exclusively as RDF is hard, and I think unwise.
I did it with imgcollect, and it was hard to do well, which means I didn't do it all that well :)
RDF is powerful, but it has a HUMONGOUS FLAW.
It lacks native support of ordered lists.

We can't accurately model a book if we can't place pages, paragraphs, and words in a specific order.
That should be the digital humanities' data-format litmus test, "How hard is it to model a book?"

There are ways of using RDF verbs to order RDF data, but they're extremely hard to update.
They're ugly for humans to read and comprehend and for our programs to manipulate.

Compare this...

	<urn:cite:perseus:collection.1> <http://www.homermultitext.org/hmt-data/schema#next> <urn:cite:perseus:collection.2>
	<urn:cite:perseus:collection.2> <http://www.homermultitext.org/hmt-data/schema#prev> <urn:cite:perseus:collection.1>
	<urn:cite:perseus:collection.2> <http://www.homermultitext.org/hmt-data/schema#next> <urn:cite:perseus:collection.3>
	<urn:cite:perseus:collection.3> <http://www.homermultitext.org/hmt-data/schema#prev> <urn:cite:perseus:collection.2>
	<urn:cite:perseus:collection.3> <http://www.homermultitext.org/hmt-data/schema#next> <urn:cite:perseus:collection.4>
	<urn:cite:perseus:collection.4> <http://www.homermultitext.org/hmt-data/schema#prev> <urn:cite:perseus:collection.3>

with this...

	[ 
		"urn:cite:perseus:collection.1", 
		"urn:cite:perseus:collection.2", 
		"urn:cite:perseus:collection.3", 
		"urn:cite:perseus:collection.4" 
	]


Think about all the work it takes to reorder the RDF compared with doing it in JSON.
This is one of the reasons most of our processes for updating and creating RDF triples are manual ones.
The limitations of the technology have to be worked around, and it isn't easy.
A hybrid database, like JackSON, means we can use RDF for search and categorization where it's useful.
But when we need an ordered list or when we just want id'd data and we want it in a familiar JSON format we just grab the source JSON-LD, and we can do that over a RESTFUL API.

[Manu Sporny, another JSON-LD spec author, wrote a pretty blunt essay about RDF's limitations.](http://manu.sporny.org/2014/json-ld-origins-2/)
I read it after I wrote SparqlModel and was having a battle with my conscience, and it expressed my feelings succinctly :)

I agree with him.
RDF is inadequate for modelling all the data we want, not exclusively anyway,
and we should be wary of SQL picking up RDF's slack.

# SQL to work around RDF's limitations is a bad idea.
Building a working data-model using SQL requires creating new database tables, 
writing a model class in the server's scripting language, 
and usually a Javascript class so the user's client can communicate exclusively with the model class.

Then you have to write code to change user input into a format SQL likes.
Then you have to write the code that does the reverse, 
turn SQL data into something usable by the user's client.

It's a huge time-suck to write all that code, but most developers see it as fate practically.
We all have SQL-Stockholm-Syndrome to some degree, and many of us can't see any alternatives.

My perspective is we should try to use JSON end-to-end with a little RDF on the side for searching.

# Prototype
I have a working prototype.
You may have seen the demo video I sent out a little while ago.
I've improved the prototype quite a bit since then.

Try installing it and building a little app with it.
I have a boilerplate application which shows JackSON off pretty well.
These two documents should provide you with enough background to get started

	README.md
	docs/APP.md

I'd be happy to give a personal demo too.
I think with a little polish JackSON could become a very valuable tool for us.

# Needed development
## CITE urns
I need to add better CITE URN support.
Checkout this quick example.

This JSON-LD lives here http://localhost:4567/data/elem/he and it looks like this...

	{
	    "@context": {
	        "mass": "http://localhost:4567/apps/elem/schema#mass",
	        "name": "http://localhost:4567/apps/elem/schema#name",
	        "number": "http://localhost:4567/apps/elem/schema#number",
	        "symbol": "http://localhost:4567/apps/elem/schema#symbol",
	        "urn": "http://github.com/caesarfeta/JackSON/docs/SCHEMA.md#urn"
	    },
	    "mass": "6.64648x10^-24",
	    "name": "Helium",
	    "number": "2",
	    "symbol": "He",
	    "urn": "urn:cite:periodic:elem.2"
	}

When run through JackRDF it produces this...

	<http://localhost:4567/data/elem/he> <http://github.com/caesarfeta/JackSON/docs/SCHEMA.md#urn> "urn:cite:periodic:elem.2"
	<http://localhost:4567/data/elem/he> <http://localhost:4567/apps/elem/schema#mass> "6.64648x10^-24"
	<http://localhost:4567/data/elem/he> <http://localhost:4567/apps/elem/schema#name> "Helium"
	<http://localhost:4567/data/elem/he> <http://localhost:4567/apps/elem/schema#number> "2"
	<http://localhost:4567/data/elem/he> <http://localhost:4567/apps/elem/schema#symbol> "He"

Having the URL to the source JSON-LD as the subject node of the RDF is nice in some ways.
The source JSON-LD is just a click or URL away.
I figured the URL is a perfectly good global identifier once the JackSON server is being hosted publicly.
The very nature of the HTTP protocol ensures these ids are unique too, so there doesn't have to be a central unique id authority.
DNS handles this for us.

And it will totally work if the JSON-LD never needed to be moved to a different host.
Which IS a problem because we can't do a global find and replace of that URL.
Other people are referencing it after all.

So we have to decouple the RDF subject id from the JSON-LD source URL.
Our preferred way of doing this as an organization is to use CITE URNs.

One solution to this problem is if the JSON-LD has a defined urn key-value pair and the urn key is mapped to a very specific RDF verb like in the example...

	...
	"urn": "http://github.com/caesarfeta/JackSON/docs/SCHEMA.md#urn"
	...
	"urn": "urn:cite:periodic:elem.2"
	...

It could produce RDF like this instead.

	<urn:cite:periodic:elem.2> <http://github.com/caesarfeta/JackSON/docs/SCHEMA.md#src> "http://localhost:4567/data/elem/he"
	<urn:cite:periodic:elem.2> <http://localhost:4567/apps/elem/schema#mass> "6.64648x10^-24"
	<urn:cite:periodic:elem.2> <http://localhost:4567/apps/elem/schema#name> "Helium"
	<urn:cite:periodic:elem.2> <http://localhost:4567/apps/elem/schema#number> "2"
	<urn:cite:periodic:elem.2> <http://localhost:4567/apps/elem/schema#symbol> "He"

Retrieving the source JSON-LD by URN could be done like so.

	http://localhost:4567/urn?cite=urn:cite:periodic:elem.2

This would allow multiple JSON-LD files to add verbs and values to one RDF node.
This JSON-LD lives here http://localhost:7890/data/chem-hist/he and it looks like this...

	{
	    "@context": {
	        "discoverer": "http://localhost:7890/apps/chem-hist/schema#discoverer",
			"urn": "http://github.com/caesarfeta/JackSON/docs/SCHEMA.md#urn"
	    },
	    "discoverer": [ "Jules Janssen", "Norman Lockyer", "Per Teodor Cleve", "Nils Abraham Langlet" ],
	    "urn": "urn:cite:periodic:elem.2"
	}

All together you'd have these triples...

	<urn:cite:periodic:elem.2> <http://github.com/caesarfeta/JackSON/docs/SCHEMA.md#src> "http://localhost:4567/data/elem/he"
	<urn:cite:periodic:elem.2> <http://github.com/caesarfeta/JackSON/docs/SCHEMA.md#src> "http://localhost:7890/data/chem-hist/he"
	<urn:cite:periodic:elem.2> <http://localhost:4567/apps/elem/schema#mass> "6.64648x10^-24"
	<urn:cite:periodic:elem.2> <http://localhost:4567/apps/elem/schema#name> "Helium"
	<urn:cite:periodic:elem.2> <http://localhost:4567/apps/elem/schema#number> "2"
	<urn:cite:periodic:elem.2> <http://localhost:4567/apps/elem/schema#symbol> "He"
	<urn:cite:periodic:elem.2> <http://localhost:7890/apps/chem-hist/schema#discoverer> "Jules Janssen"
	<urn:cite:periodic:elem.2> <http://localhost:7890/apps/chem-hist/schema#discoverer> "Norman Lockyer"
	<urn:cite:periodic:elem.2> <http://localhost:7890/apps/chem-hist/schema#discoverer> "Per Teodor Cleve"
	<urn:cite:periodic:elem.2> <http://localhost:7890/apps/chem-hist/schema#discoverer> "Nils Abraham Langlet"

It makes deleting triples associated with a deleted JSON-LD a bit tricky, but it can certainly be done.
If the source JSON-LD files are moved we can update the appropriate RDF objects.
Data migrations are never fun, but doing a text find and replace on some URLs isn't too painful.
Even if they number in the tens of thousands it is not that hard.

Also it's not costly to do the URN lookup.
It's essentially just running this SPARQL query.

	SELECT ?o WHERE { <urn:cite:periodic:elem.2> <http://github.com/caesarfeta/JackSON/docs/SCHEMA.md#src> ?o }

We could use this to locate RDF associated with a URN across several JackSON instances.
Ideally it would be nice to have all RDF data at one SPARQL endpoint but that may not be practical.
JackSON instances might be connected with different SPARQL endpoints.

Each JackSON instance could store the URLs to all SPARQL endpoints.
When it's not certain which endpoint contains the RDF we want we can just issue requests to all of them.
AJAX requests aren't that costly to make, and they're asynchronous.
One or more of them can return urls to the source JSON-LD data.
Then using AJAX, retrieve the source JSON-LD.

This means the system can scale horizontally fairly well.

## Authentication
We need some kind of authentication system.
One to mark applications as able to POST PUT and DELETE to JackSON.
Otherwise making a JackSON server public is flirting with data-danger!

## Validation
We'll need a validation system to ensure JSON uploaded to the server isn't junk.
I started writing this... see the validation branch.
It operates by through a validation JSON file, which will check for the presence of certain key-value pairs,
whether those values are the correct datatype,
and check values more granularly with regex if need be.

We just need a JSON-LD template to describe a datamodel and a JSON validation config to enforce it.

( docs/APP.md ### Validate uploaded JSON ) explains it in more detail.

## Versioning
This is something I've just day-dreamt about but I haven't taken the plunge in developing,
but we could integrate JackSON with Git.
When JSON is changed it could trigger a git commit.
Then that commit hash could become an additional identifier for retrieving versions of JSON, and can be suffixed to RDF triples.

