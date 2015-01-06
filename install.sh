#!/bin/bash

# Install rake and third-party gems
gems () {
  bundle install
}

# Build JackRDF
jackrdf () {
  git clone https://github.com/caesarfeta/JackRDF /var/www/JackRDF
  cd /var/www/JackRDF
  rake install
}

# gems
jackrdf