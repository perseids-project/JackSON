#!/bin/bash

# Works with Ubuntu 12.04
# Install rbenv
i_rbenv () {
  git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
  echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bash_profile
  echo 'eval "$(rbenv init -)"' >> ~/.bash_profile
  source ~/.bash_profile
}
i_ruby_build () {
  git clone https://github.com/sstephenson/ruby-build.git ~/ruby-build
  cd ~/ruby-build
  ./install.sh
}

# Install rake and third-party gems
gems () {
  gem install bundler
  gem install erubis
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
#sudo apt-get update
#i_rbenv
#i_ruby_build
rbenv install 1.9.3-p0
rbenv global 1.9.3-p0
rbenv rehash
#gems
#sparql_model
#jackrdf
