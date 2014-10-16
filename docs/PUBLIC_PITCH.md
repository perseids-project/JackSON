## Why use it?
Traditionally data driven web-applications use a relational database to store user data.
This requires developers to write model classes which transform data from a form transferrable over HTTP to tabular data using SQL.
Then to get data out of the relational database you have to do the reverse.
It's a huge time-suck and the source of a lot of frustration.
There are libraries which make this process a bit easier, ActiveRecord for example, but they're just abstractions of a cumbersome system.
There are more elegant ways of storing user data on a server.
The easiest is just saving JSON sent over HTTP.

### JSON
JSON can be manipulated natively with Javascript.
Javascript is what you have to write if you want an interactive web-application.
Given this reality, why are we still developing around relational data-bases, when we can just save a JSON data structure to the server and retrieve it exactly as it was last saved?
If we start doing that we can forego writing all the code needed to transform the data back-and-forth just for the relational database's sake. 

Right? 
Well... no... JSON saved on a traditional filesystem is hard to search.
An application without search will be a limited and lonely one.
A searchable database of some kind is needed.
Luckily there are alternatives to relational databases.
One alternative is the **RDF triple-store**.

### Linked-data and RDF triple-stores
Linked-data is simply applying the World Wide Web's "linked documents with global ids" model applied at the data level.
Each unit of data has a universally unique identifier and is connected to all other universally id'd data through formally defined relationships,

The preferred format for created linked-data is RDF.
RDF is essentially data encoded in a simple declarative sentence: subject, verb, object.
With a natural language, like English, sentences like these...

	Dick likes Jane.
	Jane pets Spot.
	Spot buries bones.

...grouped together, are creating implied relationships between all the nouns.

What's the link between Dick and bones? 
Jane, whom Dick likes, pets Spot, who buries bones.

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
The JackSON server includes a boilerplate application that can be modified to build useful applications in hours, because the unnecessarily hard part of web-development has been removed...

Creating data models ( which used to mean writing CREATE TABLE statements, server-side model classes, and a client-side API, in three different languages ) has been greatly simplified with JackSON.

All you have to do is write a JSON template.
Actually all you have to do is modify the JSON template in the boilerplate application.
Developing that template is a very visual process too.
Try it!
Fork this project, install it, and then read **docs/APP.md**