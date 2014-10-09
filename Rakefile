require 'rake/testtask'
require 'yaml'

@settings = YAML.load( File.read( "JackSON.config.yml" ) )

Rake::TestTask.new do |t|
  t.libs = ['test']
  t.warning = true
  t.verbose = true
  t.test_files = FileList[ 'test/unit/*rb', 'test/integration/*rb' ]
end

desc "Run tests"
task :default => :test

desc "Start a development console"
task :console do
  dir = File.dirname(__FILE__)
  exec "irb -I #{dir} -r 'JackSON.server.rb'"
end

namespace :server do
  desc "Start the server at port #{@settings["port"]}"
  task :start do
    `ruby JackSON.server.rb`
  end
end

namespace :app do
  desc 'Create a new app in public/apps/'
  task :make, :proj do |t,args|
    
    # Input check
    proj = args[:proj]
    if proj.nil?
      throw "A project name is needed -- rake app:create['name']" 
      return
    end
    if File.directory?( proj )
      throw "Project #{proj} already exists"
      return
    end
    
    # Add Foundation
    Dir.chdir( @settings["apps"] )
    `foundation new #{proj}`
    Dir.chdir( proj )
    `bundle`
    
    # Add boilerplate js css and html
    FileUtils.cp_r( '../boilerplate/angular', 'angular' )
    FileUtils.cp( '../boilerplate/_index.html', 'index.html' )
    FileUtils.cp( '../boilerplate/_foundation.html', 'foundation.html' )
    FileUtils.cp( '../boilerplate/_app.scss', 'scss/app.scss' )
    FileUtils.cp( '../boilerplate/_schema', 'schema' )
    
    # Replace strings in the angular/*.js files
    Dir.glob( 'angular/*.js' ) do |fn|
      text = File.read(fn)
      replace = text.gsub( 'boilerplate', proj )
      File.open(fn,'w'){ |file| file.puts replace }
    end
    
    # Compass will watch SCSS updates
    `bundle exec compass watch`
  end
  
  desc 'Delete an app in public/apps/'
  task :rm, :proj do |t,args|
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
    `git submodule update --init`
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