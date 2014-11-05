require 'rake/testtask'
require 'yaml'
require 'find'
require 'shellwords'
require 'erubis'
require_relative 'lib/JackHELP'

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

# Server
namespace :server do
  desc "Start the server at port #{@settings["port"]}"
  task :start do
    `ruby JackSON.server.rb`
  end
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
  task :make do
    tmake
  end
  desc 'Destroy all RDF triples in Fuseki'
  task :destroy do
    Dir.chdir( "../JackRDF" )
    exec 'rake data:destroy'
  end
end

def tmake_dir
  "#{@settings["tmp"]}/triple-make"
end

def tmake_file( file )
  "#{tmake_dir}/#{file}"
end

def tmake
  # Check for the existence of previously run task
  if File.directory?( tmake_dir )
    STDOUT.puts "#{tmake_dir} exists.
Remove the previous run's output? (y/n)"
    input = STDIN.gets.strip
    case input 
    when 'y'
      FileUtils.rm_rf( tmake_dir )
    else
      abort("**task cancelled**")
    end
  end
  
  # Get the paths of the JSON files in the data dir
  files = JackHELP.run.files_matching( @settings["path"], /.*\.json$/ )
  
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
      JackHELP.run.rdf( "POST", @settings['sparql'], "#{@settings["host"]}/#{path}", json )
    rescue Exception => e
      errors.puts(e)
    end
    done.puts(json)
  end
end

# Install
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
    #`rbenv rehash`
  end
end

# JSON
namespace :json do
  desc 'Destroy all json data'
  task :destroy do
    STDOUT.puts "Sure you want to destroy all JSON in \"#{@settings["path"]}/\"? (y/n)"
    input = STDIN.gets.strip
    if input == 'y'
      FileUtils.rm_rf( @settings["path"] )
      FileUtils.mkdir( @settings["path"] )
    else
      STDOUT.puts "No data was destroyed.  It's still all there :)"
    end
  end
  desc "Change URLs by modifying JSON-LD in-place"
  task :change, :old, :neu do |t,args|
    old = Shellwords.escape( args[:old] )
    neu = Shellwords.escape( args[:neu] )
    `grep -rl \"#{old}\" #{@settings["path"]} | xargs sed -i \"\" \"s?#{old}?#{neu}?g\"`
  end
end

# Data
namespace :data do
  desc 'Destroy all data'
  task :destroy do
    Rake::Task['json:destroy'].invoke
    Rake::Task['triple:destroy'].invoke
  end
  desc 'Create fake data from a template'
  task :fake, :tmpl, :gen, :n, :dir do |t,args|
    require 'faker'
    # Get parameters
    tmpl = args[:tmpl]
    n = args[:n].to_i
    dir = "#{@settings["path"]}/#{args[:dir]}"
    # Get an absolute directory path
    @settings["file"] = "#{@settings["templates"]}/#{tmpl}"
    @settings["dir"] = "#{File.dirname(__FILE__)}/#{File.dirname( @settings["file"] )}"
    puts @settings["dir"]
    gen = args[:gen]
    # Make output dir
    FileUtils.mkdir( dir )
    # Get the template
    erb = File.read( @settings["file"] )
    # Get filenames
    files = []
    n.times do
      file = "#{dir}/#{Faker::Internet.slug(nil,"_")}.json"
      files.push( file )
    end
    # Write files
    files.each do |file|
      # Load generator each time for new random data
      load "#{@settings["templates"]}/#{gen}"
      # Reference other files << TODO
      # Generate files
      output = Erubis::Eruby.new(erb).result(:data=>@data,:settings=>@settings)
      File.open( file,"w") { |f| f.write( output ) }
    end
  end
end