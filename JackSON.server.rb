require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/config_file'
require 'sinatra/cross_origin'
require 'json'
require 'github/markup'
require 'fileutils'
require 'open-uri'
require 'rest_client'

# Custom JackSON helpers

require 'JackRDF'
require_relative 'lib/String'
require_relative 'lib/JackHELP'
require_relative 'lib/JackVALID'
require_relative 'lib/JackGUARD'

# Yes I want logging!

require 'logger'
enable :logging

# Yes I want CORS support

enable :cross_origin

# How is the server configured?

config_file 'JackSON.config.yml'
set :port, settings.port
set :bind, settings.addr


# non-YAML file configuration

configure do
  
  # Store the data-subdirectory to config mapping

  set :map, JSON.parse( File.read( "#{settings.guard}/map.json" ) )
  set :guards, {}
end


# Helper functions

helpers do
    
    
  # Build the local path to a JSON file from a url
  
  def json_file( url )
    JackHELP.run.json_file( "#{settings.path}/#{url}" )
  end
  
  # Build the path to a JSON config file in conf directory
  
  def guard_file( file )
    JackHelp.run.json_file( "#{settings.guard}/#{file}.json" )
  end
  
  
  # Write the JSON file
  
  def write_json( data, file )
    JackHELP.run.write_json( data, file )
  end
  
  
  # Remove empty parent directories recursively.
  
  def rm_empty_dirs( dir )
    JackHELP.run.rm_empty_dirs( dir )
  end
  
  
  # Shorter...
  
  def path( params )
    params[:splat][0]
  end
  
  
  # The URL to the SPARQL query endpoint
  
  def sparql_url( query )
    "#{settings.sparql}/query?query=#{ URI::escape( query, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]")) }"
  end
  
  
  # Hashify SPARQL data
  
  def sparql_hash( query )
    JSON.parse( RestClient.get( sparql_url( query ) ) )
  end


  # This is the real url to the data object being stored
  
  def data_url( pth )
    
    if defined? settings.base_url
      base_url = settings.base_url
    else
      base_url = "#{request.env['rack.url_scheme']}://#{request.host_with_port}"
    end
    return "#{base_url}/data/#{pth}"
  end
  

  # This is the (theoretically) stable url for the data item
  # as recorded to the triple store
  
  def data_src_url( request ) 
    
    # Use the configured uri_prefix over the request url if we have it
    
    if defined? settings.uri_prefix
      src_url = request.url
    else
      src_url = "#{settings.uri_prefix}#{request.path}"
    end
    return src_url
  end
 
  # Return JackRDF object
  
  def jack
    ontology = { 'uri_prefix' => "http://data.perseus.org/collections/urn:",
                 'src_verb' => settings.src_verb 
               }
    JackRDF.new( settings.sparql, ontology)
  end
  
  
  # Run a command
  # ls is the only available command
  # data/path/to/dir?cmd=ls
  
  def run( cmd, pth )
    valid = ['ls']
    if cmd == nil
      status 404
      return { :error => "No command was passed to ?cmd=" }.to_json
    end
    if valid.include?(cmd) == false
      status 404
      return { :error => "#{cmd} is not a valid command" }.to_json
    end
    case cmd
    when 'ls'
      files = []
      dirs = []
      Dir["data/#{pth}/*"].map{|item| 
        if File.directory?(item)
          dirs.push( "#{data_url(pth)}/#{File.basename(item)}?cmd=ls" )
          next
        end
        file = File.basename(item).gsub(/\.json/,'')
        files.push( "#{data_url(pth)}/#{file}" )
      }
      return { :dirs => dirs, :files => files  }.to_json
    end
  end
  
  
  # Not all browsers support PUT & DELETE
  # This allows for pseudo HTTP methods over POST
  
  def _post( pth, file )
    
    # check if file already exists
    
    if File.exist?( file )
      status 403
      return { :error => "#{data_url(pth)} already exists.  Use PUT to change" }.to_json
    end
    
    # guard input
    
    guard( pth, file )
    
    # write JSON to disk
    
    FileUtils.mkdir_p( File.dirname( file ) )
    write_json( @json, file )
    
    # convert to RDF
    
    begin
      rdf = jack()
      rdf.post( data_src_url(request), file )
    rescue JackRDF_Critical => e
      return { :error => e }.to_json
    rescue Exception => e
      return { :error => e }.to_json
    end
    
    # send success message
    
    { :success => " #{data_url(pth)} created" }.to_json
  end
  
  
  # Delete JSON from filesystem
  # Delete triples from Fuseki
  
  def _delete( pth, file )
    
    if File.file?( file ) == false || File.directory?( file ) == true
      status 404
      return { :error => "#{data_url(pth)} not found"}.to_json
    end
    
    File.delete( file )
    rm_empty_dirs( File.dirname( file ) )
    
    begin
      rdf = jack()
      rdf.delete( data_src_url(request), file )
    rescue JackRDF_Critical => e
      return { :error => e }.to_json
    rescue
    end
    
    { :success => "#{data_url(pth)} deleted" }.to_json
  end
  

  # Update filesystem JSON
  # Update Fuseki triples
  
  def _put( pth, file )
    
    # check if file already exists
    
    if File.exist?( file ) == false
      status 404
      return { :error => "#{data_url(pth)} does not exist.  Use POST to create" }.to_json
    end
    
    # guard input
    
    guard( pth, file )
    
    # convert to RDF
    
    rdf = jack()
    begin
      rdf.delete( data_src_url(request), file )
    rescue JackRDF_Critical => e
      return { :error => e }.to_json
    rescue
    end
    
    write_json( @json, file )
    
    begin
      rdf.post( data_src_url(request), file )
    rescue JackRDF_Critical => e
      return { :error => e }.to_json
    rescue Exception => e
      return { :error => e }.to_json
    end
    
    { :success => "#{data_url(pth)} updated" }.to_json
  end
  
  
  # Dump an object to the log files
  
  def logdump( obj )
    logger.debug obj.inspect
  end
  
  
  # Validate data
  
  def validate( data )
    required( data )
    type( data )
    regex( data )
  end
  
  
  # Make sure required data is there
  
  def required( data )
    data.each do | key, val |
      if val.has_key?('required') && val['required'] == true
        
        if @data.has_key?( key ) == false
          status 500
          return { :error => "#{key} missing" }.to_json
        end
        
      end
    end
  end
  
  
  # Make sure the data type is correct
  
  def type( data )
    data.each do | key, val |
      if val.has_key?('type')
        if @data.has_key?( key )
          
          type = @data[key].class.to_s
          check = val['type'].dequote
          
          if type != check
            status 500
            return { :error => "#{key} is #{type} and not #{check}" }.to_json
          end
          
        end
      end
    end
  end
  
  
  # Regex that heez
  
  def regex( data )
    data.each do | key, val |
      if val.has_key?('regex')
        if @data.has_key?( key )
          
          regex = Regexp.new val['regex']
          
          # Array?
          
          if @data[key].kind_of?( Array )
            @data[key].each do | item |
              regcheck( regex, item, key )
            end
          
          # scalar...  
          
          else
            regcheck( regex, @data[key], key )
          end
          
        end
      end
    end
  end
  
  
  # Check a regex item
  
  def regcheck( regex, item, key )
    if item !~ regex
      status 500
      return { :error => "#{key} value #{item} does not pass #{regex}" }
    end
  end
  
  
  # Add extra
  
  def extra( data )
  end
  
  
  # Run interference, guard.
  
  def guard( pth, file )
    pth = pth.chomp("/")
    return if has_guard?( pth ) == false
    
    guard = settings.guards[pth]
    validate( guard['@data'] )      
    extra( guard['@extra'] )
  end
  
  
  # Is there a directory level config?
  
  def has_guard?( pth )
    settings.map.each do | key, val |
      key = key.chomp("/")
      if key.include?( pth )
        
        # Add validator file to settings
        
        add_guard( pth, val )
        
        # Your job here is done
        
        return true
        
      end
    end
    
    # No guard configured...
    
    return false
    
  end
  
  
  # Add a directory level data guard to settings
  
  def add_guard( pth, val )
    if settings.guards.has_key?( pth ) == false
      settings.guards[pth] = JSON.parse( File.read( "#{settings.guard}/#{val}.json" ) )
    end
  end
  
  
  # CORS Cross Origin Resource Sharing
  # aka "allow requests from"
  
  def cors
    if settings.allow_origin.respond_to? :each
      settings.allow_origin.each do | host |
        cross_origin :allow_origin => host
      end
    else
      cross_origin :allow_origin => settings.allow_origin
    end
  end
  
end


# Retrieve JSON from HTTP request body

before do
  @root = File.dirname(__FILE__)
  logger.level = Logger::DEBUG


  # We're usually just sending json
  
  content_type :json
  
  
  # If we're dealing with a GET request we can stop here.
  # No data gets passed along.
  
  if ["GET"].include? request.request_method
    return
  end
  
  
  # Retrieve JSON body
  
  data = params[:data]
  
  
  # Different clients may use different Content-Type headers.
  # Sinatra doesn't build params object for all Content-Type headers.
  # Accomodate them.
  
  if data == nil
    begin
      data = JSON.parse( request.body.read )["data"]
    rescue
    end
  end
  @json = data.to_json
  @data = data
  
  
  # Debug logging
  
  if settings.debug == true
    logdump request
    logdump params
    logdump @json
  end
end


# Return README.md

get '/?' do
  cors
  content_type :html
  return GitHub::Markup.render( 'README.md' )
end


# This is done as a quick fix for bypassing Fuseki's CORS

# If queries need to be scrubbed or modified for performance
# this will give us a method to do that

get '/query' do
  cors
  RestClient.get sparql_url( params[:query] )
end


# Retrieve a the src JSON-LD files by URN

get '/src' do
  cors
  urn = params[:urn].dequote
  rdf = jack()
  query = "SELECT ?o WHERE { <#{urn}> <#{rdf.src_verb}> ?o }"
  begin
    r = sparql_hash( query )["results"]["bindings"]
  rescue
    return { :error => "An error occured resolving #{urn}" }.to_json
  end
  if r.length < 1
    status 404
    return { :error => "#{urn} is not mapped to a JSON-LD file" }.to_json
  end
  out = []
  r.each do |item|
    out.push item["o"]["value"]
  end
  return { :src => out }.to_json
end


# Return JSON file

get '/data/*' do
  cors
  pth = path( params )
  
  
  # Check to see if any command was passed
  
  if params.has_key?("cmd")
    cmd = params["cmd"]
    return run( cmd, pth )
  end
  
  
  # Return json file
  
  file = json_file( pth )
  if File.exist?( file ) == false
    status 404
    return { :error => "#{data_url(pth)} does not exist.  Use POST to create file" }.to_json
  end
  File.read( file )
end


# Simplest way I've found to default to index.html

get '/apps/*' do
  cors
  if params[:splat].first.index('.') == nil
    redirect File.join( 'apps', params[:splat].first, "index.html" )
  end
  index = File.join( @root, 'public/apps', params[:splat] )
  if File.exist?( index ) == false
    status 404
  end
  File.read( index )
end


# Create directory and JSON file

post '/data/*' do
  cors
  pth = path(params)
  file = json_file( pth )
  case params[:_method]
  when 'PUT'
    _put( pth, file )
  when 'DELETE'
    _delete( pth, file )
  else
    _post( pth, file )
  end
end


# Change JSON file

put '/data/*' do
  cors
  pth = path(params)
  file = json_file( pth )
  _put( pth, file )
end


# Delete a JSON file

delete '/data/*' do
  cors
  pth = path(params)
  file = json_file( pth )
  _delete( pth, file )
end
