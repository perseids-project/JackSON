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
  task :create, :proj do |t,args|
    
    # Input check
    proj = args[:proj]
    if proj.nil?
      throw "A project name is needed -- rake app:create['name']" 
    end
    if File.directory?( proj )
      throw "Project #{proj} already exists"
    end
    
    # Add Foundation
    Dir.chdir( @settings["apps"] )
    `foundation new #{proj}`
    Dir.chdir( proj )
    `bundle`
    `bundle exec compass watch`
    
    # Add Angular
    
  end
  
  desc 'Delete an app in public/apps/'
  task :delete, :proj do |t,args|
    proj = args[:proj]
    if proj.nil?
      throw "A project name is needed -- rake app:create['name']"
    end
    Dir.chdir( @settings["apps"] )
    if File.directory?( proj ) == false
      throw "Project #{proj} does not exist"
    end
    FileUtils.rm_rf( proj )
  end
end

namespace :install do
  desc 'Minimum install'
  task :min do
    `sudo gem install sinatra`
    `sudo gem install sinatra-contrib`
    `sudo gem install sinatra-reloader`
    `sudo gem install markup`
    `sudo gem install github-markup`
    `sudo gem install JackRDF`
  end
  
  desc 'Install UI toolkit'
  task :ui do
    `sudo npm install -g bower grunt-cli`
    `sudo gem install foundation`
    `sudo gem install compass`
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