JackSON
It's a RESTful API for saving JSON
	GET, POST, PUT, DELETE
It comes coupled with a JQuery-centric Javascript client, but any HTTP client can be used.
I use ruby's Rest::Client module in my unit tests for example.
I've also used Angular JS $http service to communicate with JackSON.

JackRDF
Scripts to install a Fuseki triplestore.
and a ruby gem that convertes JSON-LD to RDF and stuffs it into Fuseki.

http://localhost:4567/

http://localhost:4321/

Here's an example.

http://localhost:4567/examples/thesaurus/index.html
http://localhost:4321/ds/query?query=select+%3Fs+%3Fp+%3Fo%0D%0Awhere+%7B+%3Fs+%3Fp+%3Fo+%7D&output=text&stylesheet=

Run another instance on a different port.

The data is all linked together.
Seperate JackSON instances on different hosts can all add their converted RDF into a central Fuseki instance, so it becomes the mother brain... storing the searchable connected portions of our data.

