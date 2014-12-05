#!/bin/bash

# Install rake and third-party gems
gems () {
  bundle install
  # gem install rack rake sinatra bundler sinatra-reloader github-markup markdown rest-client erubis minitest --no-rdoc --no-ri
}

# Build SparqlModel
sparql_model () {
  git clone https://github.com/caesarfeta/sparql_model /var/www/sparql_model
  cd /var/www/sparql_model
  rake install  
}

# Build JackRDF
jackrdf () {
  git clone https://github.com/caesarfeta/JackRDF /var/www/JackRDF
  cd /var/www/JackRDF
  rake install
}

gems
sparql_model
jackrdf