# JackSON
JackSON is a lightweight server and Javascript API that will **create/POST**, **retrieve/GET**, **update/PUT**, and **delete/DELETE** JSON files RESTfully.

JackSON will also convert JSON-LD files to Fuseki served RDF automatically using [JackRDF](http://github.com/caesarfeta/jackrdf)

It was designed specifically for rapidly prototyping linked-data web applications with save and search capabilities.

# Development Installation

Fresh Install of Ubuntu 12.04

	Note I used VirtualBox for testing
	This reminder is for me...
		fn+shift UP and DOWN to terminal scroll with Macbook

### Basic Environment

	sudo apt-get update
	sudo apt-get install build-essential zlib1g-dev libssl1.0.0 libssl-dev git 

### Setup JackSON

	sudo mkdir -p /var/www
	sudo chown -R user /var/www
	git clone https://github.com/PerseusDL/JackSON /var/www/JackSON
	cd /var/www/JackSON

### Get dependencies and apps

	git submodule update --init

### Build Ruby

	cd /var/www/JackSON
	./rbenv.sh
	source ~/.bash_profile
	rbenv rehash

### Install JackSON dependencies

	sudo apt-get install rubygems
	gem install bundler
	rbenv rehash
	bundle install

### Install JackRDF
* [JackRDF README.md](https://github.com/PerseusDL/JackRDF/blob/master/README.md)


### Start JackSON

	cd /var/www/JackSON
	rake start

Make sure JackSON is running properly

	rake test

## Develop
* [Create a JackSON backed AngularJS app](docs/APP.md)
* [Contribute?](docs/DEVELOP.md)

## Useful Reading
* Manu Sporny talks about the relationship between [JSON-LD &amp; RDF](http://manu.sporny.org/2014/json-ld-origins-2/)
* [JSON-LD 1.0 W3C Recommendation](http://www.w3.org/TR/json-ld/)
* [JSON-LD RDF API Spec](http://json-ld.org/spec/latest/json-ld-rdf/)