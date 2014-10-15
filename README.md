# JackSON
JackSON is a lightweight server and Javascript API that will **create/POST**, **retrieve/GET**, **update/PUT**, and **delete/DELETE** JSON files RESTfully.

JackSON can also convert JSON-LD files to Fuseki served RDF automatically.
See [JackRDF](http://github.com/caesarfeta/jackrdf).

It was designed specifically for rapidly prototyping linked-data web applications with save and search capabilities.

## Why use it?
Traditionally data driven web-applications use a relational database to store user data.
This requires developers to write model classes which transform data from something transferrable over HTTP to tabular data using SQL.
Then to get data out of the relational database you have to do the reverse.
It's a huge time-suck and the source of a lot of frustration.
There are libraries which make this process a bit easier, ActiveRecord for example, but they're just abstractions of a cumbersome system.
There are more elegant ways of storing user data on a server, the easiest is just saving JSON sent over HTTP.

### JSON
JSON can be manipulated natively with Javascript.
Javascript is really your only choice for client-side scripting.
Given this reality why aren't we just saving JSON on our servers?
If we start doing that we can forego writing all the code needed to transform the data for the relational database's sake. 

Right? 
Well... no... JSON saved on a traditional filesystem is hard to search, and most applications involve searching data of some kind.  
Luckily there are alternatives to relational databases.
One alternative is the **RDF triple-store**, which will one day realize the dream of Tim Berners-Lee and his acolytes, a network of globally **linked-data**.

### Linked-data and RDF
Linked-data is simply applying the World Wide Web's "linked documents with global ids" model to the level of data.
Each unit of data has a universally unique identifier and is connected to all other universally id'd data through formally defined relationships,

The preferred format for created linked-data is RDF.
RDF is basically data encoded in a simple declarative sentence: subject, verb, object.
With a natural language, like English, sentences like these...

	Dick likes Jane.
	Jane pets Spot.
	Spot buries bones.

...grouped together, are creating implied relationships between all the nouns.

What's the link between Dick and bones? 
Jane, whom Dick likes, pets Spot, who buries bones.
Simple.

RDF actually looks more like this.

	<http://chem.org/data/elem/he> <http://chem.org/schema#name> "Helium" 
	<http://chem.org/data/elem/he> <http://chem.org/schema#number> "2"
	<http://chem.org/data/elem/he> <http://chem.org/schema#symbol> "He"
	<http://chem.org/data/elem/he> <http://chem.org/schema#prev> <http://chem.org/data/elem/h>
	<http://chem.org/data/elem/he> <http://chem.org/schema#next> <http://chem.org/data/elem/li>

...but the similarities should be apparent.

### RDF is amazing!
	TODO

### RDF sucks!!
	TODO

### JSON-LD to the rescue!!!
	TODO

### JackSON to the rescue!!!!
If you're a researcher or working with one, and are looking for a simple way to both create and publish data, JackSON is what you need.
JackSON creates a boilerplate application that can be modified to build useful applications in hours, because the unnecessarily hard part of web-development has been removed...

Creating data models ( which used to mean writing CREATE TABLE statements, server-side model classes, and a client-side API, in three different languages ) is trivial with JackSON.

All you have to do is write a JSON template.
Actually all you have to do is modify the JSON template in the boilerplate application.
Developing that template is a very visual process too.
Try it!
Fork this project, install it, and then read **docs/APP.md**

## Basics
### Install
Install ruby and gem.

Run the installer.

	rake install:min

Start the server.

	rake server:start

### CORS "Cross-origin resource sharing"
Applications that use JackSON can be hosted anywhere with one "gotcha", to communicate with the JackSON server from an application on another host you will need to update **JackSON.config.yml**

	cors: [ 'http://localhost:4567', 'http://localhost:3000', 'http://your.app-host.com' ]

That's it for basics!

## Create a JackSON app
See **docs/APP.md**

### Using  JackSON.js
If you aren't looking to create a new JackSON/Angular app and you're comfortable using JQuery checkout **docs/API.md**.

## Contribute?
If you would like to contribute code to this project see **docs/DEVELOP.md** for guidance.

## Useful Reading
* Manu Sporny talks about the relationshipe between [JSON-LD &amp; RDF](http://manu.sporny.org/2014/json-ld-origins-2/)
* [JSON-LD 1.0 W3C Recommendation](http://www.w3.org/TR/json-ld/)
* [JSON-LD RDF API Spec](http://json-ld.org/spec/latest/json-ld-rdf/)