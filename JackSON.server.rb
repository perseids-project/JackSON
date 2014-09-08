require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/config_file'
require 'json'
require 'github/markup'
config_file 'JackSON.config.yml'

# Take a url and build the path to a JSON file
helpers do
  # Build the local path to a JSON file from a url
  def json_file( url )
    if url[-5..-1] != '.json'
      url = "#{url}.json"
    end
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
end

# Retrieve JSON from HTTP request body
before do
  # CORS http://thibaultdenizet.com/tutorial/cors-with-angular-js-and-sinatra/
  headers 'Access-Control-Allow-Origin' => '*', 
          'Access-Control-Allow-Methods' => [ 'GET', 'POST', 'PUT' ]
          
  # We're usually just sending json
  content_type :json
  
  # Retrieve json body
  request.body.rewind
  @json = request.body.read
end

get '/' do
  content_type :html
  md = GitHub::Markup.render( 'README.md' )
  erb :home, :locals => { :md => md }
end

get '/dev' do
  content_type :html
  md = GitHub::Markup.render( 'CLIENT.md' )
  erb :dev, :locals => { :md => md }
end

# Return JSON file
get '/data/*' do
  File.read( json_file( path(params) ) )
end

# Create directory and JSON file
post '/data/*' do
  pth = path(params)
  file = json_file( pth )
  if File.exist?( file )
    # Maybe I should just run PUT method.
    return { :error => "JSON file at #{pth} exists.  Use PUT to change file contents" }.to_json
  end
  FileUtils.mkdir_p( File.dirname( file ) )
  write_json( @json, file )
  
  # TODO Add new file to GIT
  { :success => "JSON file successfully POSTed to #{pth}" }.to_json
end

# Change JSON file
# Commit changes to GIT
put '/data/*' do
  pth = path(params)
  file = json_file( pth )
  if File.exist?( file ) == false
    return { :error => "JSON file at #{pth} does not exist.  Use POST to create file" }.to_json
  end
  write_json( @json, file )
  
  # TODO Update GIT
  { :success => "JSON at #{pth} has been successfully updated" }.to_json
end