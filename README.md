# JackSON
JackSON is a lightweight server and Javascript API that will **create/POST**, **retrieve/GET**, **update/PUT**, and **delete/DELETE** JSON files RESTfully.

JackSON can also convert JSON-LD files to Fuseki served RDF automatically.
See [JackRDF](http://github.com/caesarfeta/jackrdf).

It was designed specifically for rapidly prototyping linked-data web applications with save and search capabilities.

## Basics
### Install
Install ruby and gem.

Run the installer.

	rake install:min

Start the server.

	rake server:start

### Using  JackSON.js
See **docs/API.md**

### CORS "Cross-origin resource sharing"
Applications that use JackSON can be hosted anywhere with one "gotcha", to communicate with the JackSON server from an application on another host you will need to update **JackSON.config.yml**

	cors: [ 'http://localhost:4567', 'http://localhost:3000', 'http://your.app-host.com' ]

That's it for basics!



## Create a JackSON app
If you want to create a JackSON app with AngularJS and Foundation boilerplate code...

[Install NodeJS](http://nodejs.org/)

Run this to install required command line tools.

	rake install:ui

Run this to create a JackSON app in apps/name

	rake app:make['name']

After running this rake command keep your terminal open so the running program can listen for changes to your .scss files.

### JackSON and AngularJS
JackSON.js is a mostly by-the-book RESTful API, so you don't have to use JackSON.js.
AngularJS's $http service works with JackSON too.

Here are some examples to get you started.

	Note: If you click these links from GitHub they won't work.
	You have to be browsing this README from your own JackSON server instance...

* [An example JackSON &amp; AngularJS app](examples/angular/index.html)
* [A more complex example](examples/thesaurus/index.html)
* [Minimal Boilerplate JackSON &amp; AngularJS app](apps/boilerplate/index.html)

### more info on JackSON app development...
See **docs/APP.md**

## Contribute
If you would like to contribute code to this project see **docs/DEVELOP.md** for guidance.



## Useful Reading
* Manu Sporny talks about the relationshipe between [JSON-LD &amp; RDF](http://manu.sporny.org/2014/json-ld-origins-2/)
* [JSON-LD 1.0 W3C Recommendation](http://www.w3.org/TR/json-ld/)
* [JSON-LD RDF API Spec](http://json-ld.org/spec/latest/json-ld-rdf/)