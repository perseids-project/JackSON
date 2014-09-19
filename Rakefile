require 'rake/testtask'
require 'yaml'

@settings = YAML.load( File.read( "JackSON.config.yml" ) )

Rake::TestTask.new do |t|
  t.libs << 'test'
end

desc "Run tests"
task :default => :test

namespace :server do
  desc "Start the server at port #{@settings["port"]}"
  task :start do
    `ruby JackSON.server.rb`
  end
end

namespace :app do
  desc 'Create a new app in public/apps/'
  task :ui, :proj do |t,args|
    Dir.chdir( @settings["apps"] )
    `foundation new #{args[:proj]} --libsass`
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
  
  desc 'Install UI toolkit'
  task :ui do
    `sudo npm install -g bower grunt-cli`
    `sudo gem install foundation`
    `rbenv rehash`
  end
end

namespace :data do
  desc 'Destroy all data'
  task :destroy do
    STDOUT.puts "Are you sure you want to destroy all JSON data? (y/n)"
    input = STDIN.gets.strip
    if input == 'y'
      FileUtils.rm_rf( @settings["path"] )
      FileUtils.mkdir( @settings["path"] )
    else
      STDOUT.puts "No data was destroyed.  It's still all there :)"
    end
  end
end