# JackSON
JackSON is a lightweight server and Javascript API that will create, retrieve, update, and delete JSON files RESTfully.

JackSON will also convert JSON-LD files to Fuseki served RDF automatically.
See [JackRDF](http://github.com/caesarfeta/jackrdf).

It was designed for rapidly prototyping Javascript applications.
For those times when MongoDB is overkill.

## Install
Install ruby and gem.

Run the installer.

	rake server:install

Update the JackSON.config.yml file.

	path: '/where/you/will/store/the/json/files'

Start the server.

	rake server:start


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

## Using the JackSON.js API
If you're reading this on GitHub see [API.md](API.md)

If you're reading this on your JackSON instance [click here](/api)

## JackSON and AngularJS
JackSON uses 4 different HTTP methods GET, POST, PUT, DELETE to interact with a JSON file at a URL like this one http://localhost:4567/data/folder/json.

This means you don't have to use the JackSON.js API. AngularJS's $http service works with JackSON as well.

[An example JackSON &amp; AngularJS app](examples/angular/index.html)

## Contribute
If you would like to contribute to this project see [DEVELOP.md](DEVELOP.md) for more details.

## Useful Reading
Manu Sporny talks about the relationshipe between [JSON-LD &amp; RDF](http://manu.sporny.org/2014/json-ld-origins-2/)

[JSON-LD 1.0 W3C Recommendation](http://www.w3.org/TR/json-ld/)

[JSON-LD RDF API Spec](http://json-ld.org/spec/latest/json-ld-rdf/)