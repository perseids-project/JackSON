# JackSON
JackSON is a lightweight server and Javascript API that will **create/POST**, **retrieve/GET**, **update/PUT**, and **delete/DELETE** JSON files RESTfully.

JackSON will also convert JSON-LD files to Fuseki served RDF automatically using [JackRDF](http://github.com/caesarfeta/jackrdf)

It was designed specifically for rapidly prototyping linked-data web applications with save and search capabilities.

## Install
If running on a fresh Ubuntu 12.04 instance...

	sudo apt-get update
	sudo apt-get install git
	sudo mkdir -p /var/www
	sudo chown -R [username]:[group] /var/www
	chmod +s /var/www
	git clone https://github.com/caesarfeta/JackSON /var/www/JackSON
	cd /var/www/JackSON

Then run the install scripts in the following order

	./setup.sh
	./rbenv.sh
	source ~/.bash_profile
	rbenv rehash
	sudo apt-get install rubygems
	gem install bundler
	rbenv rehash
	bundle install

Install [JackRDF](http://github.com/caesarfeta/jackrdf)...

## Start
	rake start

## Test
	rake test

## Develop
* [Create a JackSON backed AngularJS app](docs/APP.md)
* [Test JSON-LD templates](docs/TEMPLATES.md)
* [Contribute?](docs/DEVELOP.md)

## Useful Reading
* Manu Sporny talks about the relationship between [JSON-LD &amp; RDF](http://manu.sporny.org/2014/json-ld-origins-2/)
* [JSON-LD 1.0 W3C Recommendation](http://www.w3.org/TR/json-ld/)
* [JSON-LD RDF API Spec](http://json-ld.org/spec/latest/json-ld-rdf/)