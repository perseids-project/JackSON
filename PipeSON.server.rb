require 'sinatra'
require 'sinatra/config_file'
require 'json'
require 'github/markup'
config_file 'PipeSON.config.yml'

# Take a url and build the path to a JSON file
helpers do
  def json_file( url )
    File.join( settings.path, "#{url.to_s}.json" )
  end
end

get '/' do
  GitHub::Markup.render('README.md')
end

# Return JSON file
get '/data/*' do
  content_type :json
  File.read( json_file( params[:splat][0] ) )
end

# Create directory and JSON file
post '/data/*' do
  # mkdir -p /usr/local/PipeSON/test
  # test/data.json
end

# Change JSON file
# Commit changes to GIT
put '/data/*' do
end