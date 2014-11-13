# JackSON
JackSON is a lightweight server and Javascript API that will **create/POST**, **retrieve/GET**, **update/PUT**, and **delete/DELETE** JSON files RESTfully.

JackSON will also convert JSON-LD files to Fuseki served RDF automatically using [JackRDF](http://github.com/caesarfeta/jackrdf)

It was designed specifically for rapidly prototyping linked-data web applications with save and search capabilities.

## Install
If running on a fresh Ubuntu 12.04 instance.

	sudo ./setup.sh

Don't run ./setup.sh if you have an existing, highly custom Ruby environment!
Instead...

[Install JackRDF](http://github.com/caesarfeta/jackrdf)
Install JackSON

	rake install:min

## Start
	rake server:start

## Create a JackSON backed AngularJS app
See **docs/APP.md**

## Test JSON-LD templates
See **docs/TEMPLATES.md**

## Contribute?
See **docs/DEVELOP.md**

## Useful Reading
* Manu Sporny talks about the relationship between [JSON-LD &amp; RDF](http://manu.sporny.org/2014/json-ld-origins-2/)
* [JSON-LD 1.0 W3C Recommendation](http://www.w3.org/TR/json-ld/)
* [JSON-LD RDF API Spec](http://json-ld.org/spec/latest/json-ld-rdf/)
