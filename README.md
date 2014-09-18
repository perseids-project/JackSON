# JackSON
JackSON is a lightweight server and Javascript API that will create/POST, retrieve/GET, update/PUT, and delete/DELETE JSON files RESTfully.

JackSON will also convert JSON-LD files to Fuseki served RDF automatically.
See [JackRDF](http://github.com/caesarfeta/jackrdf).

It was designed specifically for rapidly prototyping linked-data web-applications with save and search capabilities.

## Install
Install ruby and gem.

Run the installer.

	rake install:min

Update the JackSON.config.yml file.

	path: '/where/you/will/store/the/json/files'

Start the server.

	rake server:start

## UI Development Install
You'll need NodeJs to run this...

	rake install:ui

... but after you do you'll have some nice UI design tools at your displosal thanks to [Foundation's command client](http://foundation.zurb.com/docs/sass.html).

## Development
The quickest way to begin development is to create a folder for your application like this...

	mkdir public/apps/fungus-db

Create the HTML, CSS, and Javascript files you need.
Remembering to include JQuery and JackSON.js in your application's HTML.

	<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.9.0/jquery.min.js"></script>
	<script src="http://your.jackson-server.com/JackSON.js"></script>

Now your application will be accessible at this URL.

	http://localhost:4567/apps/fungus-db

Applications that use JackSON can be hosted anywhere with one "gotcha", to communicate with the JackSON server from an application on another host you will need to update **JackSON.config.yml**

	cors: [ 'http://localhost:4567', 'http://localhost:3000', 'http://your.app-host.com' ]

## Using  JackSON.js
* If you're reading this on GitHub see [API.md](API.md)
* If you're reading this on your JackSON instance [click here](/api)

## JackSON and AngularJS
JackSON.js is a mostly by-the-book RESTful API, so you don't have to use JackSON.js.
AngularJS's $http service works with JackSON as well.

Here are some examples to get you started.

* [An example JackSON &amp; AngularJS app](examples/angular/index.html)
* [A more complex example](examples/angular/index.html)
* [Minimal Boilerplate JackSON &amp; AngularJS app](apps/boilerplate/index.html)

## Contribute
If you would like to contribute code to this project see [DEVELOP.md](DEVELOP.md) for guidance.

## Useful Reading
* Manu Sporny talks about the relationshipe between [JSON-LD &amp; RDF](http://manu.sporny.org/2014/json-ld-origins-2/)
* [JSON-LD 1.0 W3C Recommendation](http://www.w3.org/TR/json-ld/)
* [JSON-LD RDF API Spec](http://json-ld.org/spec/latest/json-ld-rdf/)