require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/config_file'
require 'json'
require 'github/markup'
require 'fileutils'
require 'pathname'
config_file 'JackSON.config.yml'

# Take a url and build the path to a JSON file
helpers do
  # Build the local path to a JSON file from a url
  def json_file( url )
    if url[-5..-1] != '.json'
      url = "#{url}.json"
    end
    url = Pathname.new( url ).cleanpath.to_s
    File.join( settings.path, url )
  end
  
  # Shorter...
  def path( params )
    params[:splat][0]
  end
  
  # Write the JSON file
  def write_json( data, file )
    File.open( file, "w+" ) do |f|
      f.write( data )
    end
  end
  
  def rm_empty_dirs( dir )
    if ( Dir.entries( dir ) - %w{ . .. .DS_Store } ).empty?
      FileUtils.rm_rf( dir )
      rm_empty_dirs( File.dirname( dir ) )
    end
  end
  
  # Not all browsers suppor PUT & DELETE
  def _post( pth, file )
    if File.exist?( file )
      status 403
      return { :error => "#{pth} already exists.  Use .put() to change file" }.to_json
    end
    FileUtils.mkdir_p( File.dirname( file ) )
    write_json( @json, file )
  
    # TODO Add new file to GIT
    { :success => " #{pth} created." }.to_json
  end
  
  def _delete( pth, file )
    if File.file?( file ) == false || File.directory?( file ) == true
      status 404
      return { :error => "#{pth} not found."}.to_json
    end
    File.delete( file )
    rm_empty_dirs( File.dirname( file ) )
    { :success => "#{pth} deleted." }.to_json
  end
  
  def _put( pth, file )
    if File.exist?( file ) == false
      status 404
      return { :error => "#{pth} does not exist.  Use .post() to create file" }.to_json
    end
    write_json( @json, file )
  
    # TODO Commit changes to GIT
    { :success => "#{pth} updated" }.to_json
  end
  
end

# Retrieve JSON from HTTP request body
before do
  # CORS
  headers 'Access-Control-Allow-Origin' => '*', 
          'Access-Control-Allow-Methods' => [ 'GET', 'POST', 'PUT', 'DELETE', 'OPTIONS' ]
          
  # We're usually just sending json
  content_type :json
  
  # Retrieve json body
  data = params[:data]
  @json = data.to_json
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
    return { :error => "#{pth} does not exist.  Use .post() to create file" }.to_json
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