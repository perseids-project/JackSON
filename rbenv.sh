#!/bin/bash

# Install rbenv
install_rbenv () {
  git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
  echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bash_profile
  echo 'eval "$(rbenv init -)"' >> ~/.bash_profile
}

# Install ruby-build
install_ruby_build () {
  git clone https://github.com/sstephenson/ruby-build.git ~/ruby-build
  cd ~/ruby-build
  sudo ./install.sh
}

# Make ruby 1.9.3 the default
install_ruby193 () {
  source ~/.bash_profile
  rbenv install 1.9.3-p0
  rbenv global 1.9.3-p0
  rbenv rehash
}

install_rbenv
install_ruby_build
install_ruby193
