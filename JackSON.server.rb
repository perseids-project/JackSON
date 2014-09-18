require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/config_file'
require 'json'
require 'github/markup'
require 'fileutils'

require 'JackRDF'
require_relative 'JackHELP'

require 'logger'
enable :logging

config_file 'JackSON.config.yml'
set :port, settings.port

helpers do
    
  # Build the local path to a JSON file from a url
  def json_file( url )
    JackHELP.run.json_file( settings.path, url )
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
  
  def data_url( pth )
    "#{request.env['rack.url_scheme']}://#{request.host_with_port}/data/#{pth}"
  end
  
  # Return JackRDF object
  def jack()
    JackRDF.new( settings.sparql )
  end
  
  # Not all browsers support PUT & DELETE
  # This allows for pseudo HTTP methods over POST
  def _post( pth, file )
    if File.exist?( file )
      status 403
      return { :error => "#{data_url(pth)} already exists.  Use PUT to change" }.to_json
    end
    
    # Create on filesytem
    FileUtils.mkdir_p( File.dirname( file ) )
    write_json( @json, file )

    # Insert into Fuseki
    begin
      rdf = jack()
      rdf.post( request.url, file )
    rescue
    end
    
    # TODO GIT?
    { :success => " #{data_url(pth)} created" }.to_json
  end
  
  def _delete( pth, file )
    if File.file?( file ) == false || File.directory?( file ) == true
      status 404
      return { :error => "#{data_url(pth)} not found"}.to_json
    end
    
    # Delete from filesystem
    File.delete( file )
    rm_empty_dirs( File.dirname( file ) )
    
    # Delete from Fuseki
    begin
      rdf = jack()
      rdf.delete( request.url )
    rescue
    end
    
    # TODO GIT?
    { :success => "#{data_url(pth)} deleted" }.to_json
  end
  
  def _put( pth, file )
    if File.exist?( file ) == false
      status 404
      return { :error => "#{data_url(pth)} does not exist.  Use POST to create" }.to_json
    end
    
    # Update filesystem
    write_json( @json, file )
    
    # Update Fuseki
    begin
      rdf = jack()
      rdf.put( request.url, file )
    rescue
    end
    
    # TODO GIT?
    { :success => "#{data_url(pth)} updated" }.to_json
  end
  
  # Dump an object to the log files
  def logdump( obj )
    logger.debug obj.inspect
  end
  
end

# Retrieve JSON from HTTP request body
before do
  
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
  
  # Retrieve json body
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

get '/' do
  content_type :html
  md = GitHub::Markup.render( 'README.md' )
  erb :home, :locals => { :md => md }
end

get '/api' do
  content_type :html
  md = GitHub::Markup.render( 'API.md' )
  erb :api, :locals => { :md => md }
end

# Return json file
get '/data/*' do
  pth = path(params)
  file = json_file( pth )
  if File.exist?( file ) == false
    status 404
    return { :error => "#{data_url(pth)} does not exist.  Use POST to create file" }.to_json
  end
  File.read( file )
end

# Create directory and json file
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

# Change json file
put '/data/*' do
  pth = path(params)
  file = json_file( pth )
  _put( pth, file )
end

# Delete a json file
delete '/data/*' do
  pth = path(params)
  file = json_file( pth )
  _delete( pth, file )
end