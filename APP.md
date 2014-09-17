# Building Linked-Data Apps with JackSON

## Thinking about the application's data structure
### Questions to ask yourself before beginning.

1. What data needs gathering?
2. What data needs to be searchable?

The answers to these questions will affect the flavor and design of your JSON.
If you don't need your data searchable just use JSON.

	{
	  "name": "Manuel Surly",
	  "homepage": "http://manuel.surly.org/",
	  "avatar": "http://twitter.com/account/profile_image/manuelsurly",
	}

To make this data SPARQL searchable use JSON-LD by adding @context and defining each property with the desired RDF ontology URL.

	{
	  "@context": {
	    "name": "http://xmlns.com/foaf/0.1/name",
	    "homepage": "http://xmlns.com/foaf/0.1/homepage",
	    "avatar": "http://xmlns.com/foaf/0.1/avatar"
	  },
	  "name": "Manuel Surly",
	  "homepage": "http://manuel.surly.org/",
	  "avatar": "http://twitter.com/account/profile_image/manuelsurly"
	}

The JSON-LD posted to **rdf/ld** produces these RDF triples.

	<http://localhost:4567/data/rdf/ld> <http://xmlns.com/foaf/0.1/avatar> "http://twitter.com/account/profile_image/manuelsurly"
	<http://localhost:4567/data/rdf/ld> <http://xmlns.com/foaf/0.1/homepage> "http://manuel.surly.org/"
	<http://localhost:4567/data/rdf/ld> <http://xmlns.com/foaf/0.1/name> "Manuel Surly"

Any property in the JSON which is not defined in @context will not produce an RDF triple.
Which means this JSON-LD...

	{
	  "@context": {
	    "name": "http://xmlns.com/foaf/0.1/name",
	    "homepage": "http://xmlns.com/foaf/0.1/homepage",
	    "avatar": "http://xmlns.com/foaf/0.1/avatar"
	  },
	  "name": "Manuel Surly",
	  "homepage": "http://manuel.surly.org/",
	  "avatar": "http://twitter.com/account/profile_image/manuelsurly",
	  "extra": "What happens when something extra is sent along?"
	}

which has a property "extra" not defined in @context, when posted to **rdf/ld** produces the same RDF as the JSON-LD without "extra"...

	<http://localhost:4567/data/rdf/ld> <http://xmlns.com/foaf/0.1/avatar> "http://twitter.com/account/profile_image/manuelsurly"
	<http://localhost:4567/data/rdf/ld> <http://xmlns.com/foaf/0.1/homepage> "http://manuel.surly.org/"
	<http://localhost:4567/data/rdf/ld> <http://xmlns.com/foaf/0.1/name> "Manuel Surly"

"extra" values will not be searchable by SPARQL, but can be retrieved pretty easily.  Since the subject of each triple is a URL to the RDF's source JSON-LD file, making a GET request to **http://localhost:4567/data/rdf/ld** will allow you to retrieve any "extra" properties not accessible in RDF.

You may be wondering why you would ever retrieve source JSON-LD.  Why not just use RDF returned by SPARQL queries?  The answer is, "You'll eventually need to make a list."

### RDF and Lists
RDF can't preserve the sequence of items in a list.
The creators of the RDF standard seem idealogically opposed to it in fact.

Pretend we are building a job application system.
We want to store an applicant's last three employers in chronological order.
We can do this easily with JSON-LD

	{
	  "@context": {
	    "name": "http://xmlns.com/foaf/0.1/name",
		"employers": "http://xmlns.com/foaf/0.1/organization"
	  },
	  "name": "Manuel Surly",
	  "employers": [ "Smallville Gazette", "Burger Barn", "Bruno's Bar & Grill" ]
	}

When this JSON-LD is posted to **rdf/ld_list** it produces RDF like this...

	<http://localhost:4567/data/rdf/ld_list> <http://xmlns.com/foaf/0.1/name> "Manuel Surly"
	<http://localhost:4567/data/rdf/ld_list> <http://xmlns.com/foaf/0.1/organization> "Burger Barn"
	<http://localhost:4567/data/rdf/ld_list> <http://xmlns.com/foaf/0.1/organization> "Smallville Gazette"                               
	<http://localhost:4567/data/rdf/ld_list> <http://xmlns.com/foaf/0.1/organization> "Bruno's Bar & Grill" 

The original sequence of employers is not encoded in these RDF triples.
Queries might return these triples in any permutation.

	<http://localhost:4567/data/rdf/ld_list> <http://xmlns.com/foaf/0.1/organization> "Burger Barn"
	<http://localhost:4567/data/rdf/ld_list> <http://xmlns.com/foaf/0.1/organization> "Bruno's Bar & Grill" 
	<http://localhost:4567/data/rdf/ld_list> <http://xmlns.com/foaf/0.1/organization> "Smallville Gazette"                               

Trying to preserve order in RDF is hard.
[Smart people are working on it.](http://infolab.stanford.edu/~stefan/daml/order.html)

If you don't want to deal with those headaches just GET the source JSON-LD.