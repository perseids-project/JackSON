require 'rubygems'
require 'rake/testtask'
require 'yaml'
require 'find'
require 'shellwords'
require 'erubis'
require_relative 'lib/JackHELP'

@settings = YAML.load( File.read( "JackSON.config.yml" ) )

desc "Run tests"
task :test do |t|
  out = [
    "Both the JSON and Fuseki triples will be destroyed by running this test suite.",
    "Are you OK with that? (y/n)"
  ]
  STDOUT.puts out.join("\n")
  input = STDIN.gets.strip
  if input == 'y'
    
    # Clear out current data
    
    JackHELP.run.destroy_data();
    
    # Run tasks
    
    Rake::TestTask.new do |t|
      t.libs = ['test']
      t.test_files = FileList[ 
        'test/integration/test_foobar.rb',
        'test/integration/test_rdf.rb'
      ]
    end
    
  else
    out = [
      "No data was destroyed.",
      "It's still all there :)",
      "I won't run the tests though..."
    ]
    STDOUT.puts out.join("\n")
  end
end


desc "Start a development console"
task :console do
  dir = File.dirname(__FILE__)
  exec "irb -I #{dir} -r 'JackSON.server.rb'"
end


# Start server

desc "Start the server at port #{@settings["port"]}"
task :start do
  `ruby JackSON.server.rb`
end


# App

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


# Triples

namespace :triple do 
  
  desc 'Update Fuseki from saved JSON-LD'
  task :make, :default do |t,args|
    
    # Input check
    
    default = args[:default]
    tmake( default )
  end
  
  desc 'Destroy all RDF triples in Fuseki'
  task :destroy do
    JackHELP.run.destroy_triples();
  end
  
end


def tmake_dir
  "#{@settings["tmp"]}/triple-make"
end


def tmake_file( file )
  "#{tmake_dir}/#{file}"
end


def tmake( default )
  
  # Check for the existence of previously run task
  
  if File.directory?( tmake_dir )
    FileUtils.rm_rf( tmake_dir )
  end
  
  # Get the paths of the JSON files in the data dir
  
  files = JackHELP.run.files_matching( @settings["path"], /.*\.json$/ )
  
  # Loop through files ignoring those starting with '/data/default'
  
  if default != true
    clean = []
    beatit = []
    files.each do |file|
      if file.include? "#{@settings["path"]}/default"
        next
      end
      clean.push file
    end
    files = clean
  end
  
  # Create the temp work directory
  
  FileUtils.mkdir_p( tmake_dir )
  errors = File.open(tmake_file('ERRORS'),"w")
  in_proc = File.open(tmake_file('IN_PROC'),"w")
  done = File.open(tmake_file('DONE'),"w")
  todo = File.open(tmake_file('TODO'),"w") do |todo|
     files.each{|file| todo.puts(file) } # Append TODO with file paths
  end
  
  # Start building those triples!
  
  todo.each do |json|
    in_proc.puts(json)
    path = json[0..-6] # remove .json
    begin
      JackHELP.run.rdf( "POST", @settings['sparql'], "http://localhost:#{@settings["port"]}/#{path}", json )
    rescue Exception => e
      errors.puts(e)
    end
    done.puts(json)
  end
end


# Install

namespace :install do
  
  desc 'Install server'
  task :server do
    puts `git submodule update --init`
    exec "gem install \
      sinatra sinatra-contrib sinatra-reloader \
      markup github-markup rest-client \
      minitest --no-rdoc --no-ri"
  end
  
  desc 'Install UI toolkit'
  task :ui do
    puts `npm install -g bower grunt-cli`
    exec "gem install foundation compass --no-rdoc --no-ri"
  end
  
end
task :install do
  Rake::Task["install:server"].invoke()
end


# JSON

namespace :json do
  
  desc 'Destroy all json data'
  task :destroy do
    STDOUT.puts "Sure you want to destroy all JSON in \"#{@settings["path"]}/\"? (y/n)"
    input = STDIN.gets.strip
    if input == 'y'
      JackHELP.run.destroy_json()
    else
      STDOUT.puts "No data was destroyed.  It's still all there :)"
    end
  end
  
  desc "Change URLs by modifying JSON-LD in-place"
  task :change, :stale, :fresh do |t,args|
    old = Shellwords.escape( args[:stale] )
    neu = Shellwords.escape( args[:fresh] )
    `grep -rl \"#{stale}\" #{@settings["path"]} | xargs sed -i \"\" \"s?#{stale}?#{fresh}?g\"`
  end
  
end


# Data

namespace :data do
  
  desc 'Destroy all data'
  task :destroy do
    Rake::Task['json:destroy'].invoke
    Rake::Task['triple:destroy'].invoke
  end
  
  desc 'Create fake data from a single template'
  task :fake, :tmpl, :gen, :n, :dir do |t,args|
    require 'faker'
    
    # Get ready
    
    tmpl = args[:tmpl]
    n = args[:n].to_i
    dir = "#{@settings["path"]}/#{args[:dir]}"
    
    # Build the paths you need
    
    @settings["file"] = "#{@settings["templates"]}/#{tmpl}"
    @settings["dir"] = "#{File.dirname(__FILE__)}/#{File.dirname( @settings["file"] )}"
    gen = args[:gen]
    
    # Make output dir
    
    FileUtils.mkdir( dir )
    
    # Get the template
    
    erb = File.read( @settings["file"] )
    
    # Start building filenames
    
    files = []
    n.times do
      file = "#{dir}/#{Faker::Internet.slug(nil,"_")}.json"
      files.push( file )
    end
    
    # Write fake files
    
    files.each do |file|
      
      # Load generator each time for new random data
      
      load "#{@settings["templates"]}/#{gen}"
      
      # Reference other files << TODO
      # Generate files
      
      output = Erubis::Eruby.new(erb).result(:data=>@data,:settings=>@settings)
      File.open( file,"w") { |f| f.write( output ) }
    end
    
    # Build default JSON file paths
    
    default_dir = "#{@settings["path"]}/default"
    default_json = "#{default_dir}/#{args[:dir]}.json"
    
    # Make sure you have a default directory
    
    if File.directory?( default_dir ) == false
      FileUtils.mkdir( default_dir )
    end
    
    # Clear out data generator
    
    @data.each do |key,val|
      if val.kind_of?( Array )
        @data[key] = []
        next
      end
      @data[key] = nil
    end
    
    # Create default JSONLD files
    
    output = Erubis::Eruby.new(erb).result(:data=>@data,:settings=>@settings)
    File.open( default_json,"w") { |f| f.write( output ) }
    STDOUT.puts "JSON files created in #{dir}. Default JSON file saved to #{default_json}"
  end
end
