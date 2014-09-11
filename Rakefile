require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << 'test'
end

desc "Run tests"
task :default => :test

namespace :server do
  desc 'Install dependencies'
  task :install do
    `gem install sinatra`
    `gem install sinatra-contrib`
    `gem install sinatra-reloader`
    `gem install markup`
    `gem install github-markup`
    `gem install JackRDF`
  end
  
  desc "Start the sinatra server at port 4567"
  task :start do
    `ruby JackSON.server.rb`
  end
end