#!/bin/bash

# Install rake and third-party gems
gems () {
  gem install bundler erubis --no-rdoc --no-ri
}

# Build SparqlModel
sparql_model () {
  mkdir -p /tmp
  git clone http://github.com/caesarfeta/sparql_model /tmp/sparql_model
  cd /tmp/sparql_model
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
