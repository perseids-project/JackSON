#!/bin/bash

# Install rake and third-party gems
gems () {
  gem install bundler erubis --no-rdoc --no-ri
}

# Build SparqlModel
sparql_model () {
  git clone http://github.com/caesarfeta/sparql_model /var/www/sparql_model
  cd /var/www/sparql_model
  rake install  
}

# Build JackRDF
jackrdf () {
  git clone http://github.com/caesarfeta/JackRDF /var/www/JackRDF
  cd /var/www/JackRDF
  rake install
}

gems
sparql_model
jackrdf
