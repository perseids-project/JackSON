require 'rake/testtask'
require 'yaml'

@settings = YAML.load( File.read( "JackSON.config.yml" ) )

Rake::TestTask.new do |t|
  t.libs << 'test'
end

desc "Run tests"
task :default => :test

namespace :server do

  
  desc "Start the sinatra server at port 4567"
  task :start do
    `ruby JackSON.server.rb`
  end
end

namespace :install do
  desc 'Minimum install'
  task :min do
    `gem install sinatra`
    `gem install sinatra-contrib`
    `gem install sinatra-reloader`
    `gem install markup`
    `gem install github-markup`
    `gem install JackRDF`
  end
end

namespace :data do
  desc 'Destroy all JackSON data'
  task :destroy do
    STDOUT.puts "Are you sure you want to destroy all JackSON data? (y/n)"
    input = STDIN.gets.strip
    if input == 'y'
      FileUtils.rm_rf( @settings["path"] )
      FileUtils.mkdir( @settings["path"] )
    else
      STDOUT.puts "No data was destroyed.  It's still all there :)"
    end
  end
end