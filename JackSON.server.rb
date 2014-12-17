require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/config_file'
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

# Yes I want logging!

require 'logger'
enable :logging

# How is the server configured?

config_file 'JackSON.config.yml'
set :port, settings.port
set :bind, settings.addr

helpers do
    
    
  # Build the local path to a JSON file from a url
  
  def json_file( url )
    JackHELP.run.json_file( "#{settings.path}/#{url}" )
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
  
  
  #  The URL to the SPARQL query endpoint
  
  def sparql_url( query )
    "#{settings.sparql}/query?query=#{ URI::escape( query, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]")) }"
  end
  
  
  #  Hashify SPARQL data
  
  def sparql_hash( query )
    JSON.parse( RestClient.get( sparql_url( query ) ) )
  end
  
  def data_url( pth )
    "#{request.env['rack.url_scheme']}://#{request.host_with_port}/data/#{pth}"
  end
  
  
  # Return JackRDF object
  
  def jack
    JackRDF.new( settings.sparql )
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
    if File.exist?( file )
      status 403
      return { :error => "#{data_url(pth)} already exists.  Use PUT to change" }.to_json
    end
    FileUtils.mkdir_p( File.dirname( file ) )
    write_json( @json, file )
    begin
      rdf = jack()
      rdf.post( request.url, file )
    rescue
    end
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
      rdf.delete( request.url )
    rescue
    end
    { :success => "#{data_url(pth)} deleted" }.to_json
  end
  

  
  # Update filesystem JSON
  # Update Fuseki triples
  
  def _put( pth, file )
    if File.exist?( file ) == false
      status 404
      return { :error => "#{data_url(pth)} does not exist.  Use POST to create" }.to_json
    end
    
    rdf = jack()
    begin
      rdf.delete( request.url, file )
    rescue
    end
    
    write_json( @json, file )
    
    begin
      rdf.post( request.url, file )
    rescue
    end
    { :success => "#{data_url(pth)} updated" }.to_json
  end
  
  
  # Dump an object to the log files
  
  def logdump( obj )
    logger.debug obj.inspect
  end
  
end


# Retrieve JSON from HTTP request body

before do
  @root = File.dirname(__FILE__)
  logger.level = Logger::DEBUG
  
  
  # TODO CORS
  
  headers 'Access-Control-Allow-Origin' => '*', 
          'Access-Control-Allow-Methods' => [ 'GET', 'POST', 'PUT', 'DELETE', 'OPTIONS' ]


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
  
  
  # Debug logging
  
  if settings.debug == true
    logdump request
    logdump params
    logdump @json
  end
end


# Return README.md

get '/' do
  content_type :html
  return GitHub::Markup.render( 'README.md' )
#  md = GitHub::Markup.render( 'README.md' )
#  erb :home, :locals => { :md => md }
end


# This is done as a quick fix for bypassing Fuseki's CORS

get '/query' do
  RestClient.get sparql_url( params[:query] )
end


# Retrieve a the src JSON-LD files by URN

get '/src' do
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
  pth = path( params )
  
  
  # Check to see if any command was passed
  # return { :params => params.inspect }.to_json
  
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
  pth = path(params)
  file = json_file( pth )
  _put( pth, file )
end


# Delete a JSON file

delete '/data/*' do
  pth = path(params)
  file = json_file( pth )
  _delete( pth, file )
end
