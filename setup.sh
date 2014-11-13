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
# Install ruby 1.9.3
ruby193 () {
  apt-get install ruby 1.9.3
  cd /etc/alternatives
  sudo ln -sf /usr/bin/ruby1.9.3 ruby

}
# Install rake and third-party gems
gems () {
  apt-get install rake
  gem install erubis
  apt-get install bundler
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
  mkdir -p /tmp
  git clone http://github.com/caesarfeta/JackRDF /tmp/JackRDF
  cd /var/www/JackRDF
  rake install
}
apt-get update
i_rbenv
i_ruby_build
rbenv install 1.9.3-p0
gems
sparql_model
jackrdf
