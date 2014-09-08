require 'sinatra'
require 'sinatra/config_file'
require 'json'
require 'github/markup'
config_file 'PipeSON.config.yml'

get '/' do
  GitHub::Markup.render('README.md')
end

# Return JSON file
get '/*' do
  content_type :json
  { :settings => settings.path, :id => params[:splat] }.to_json
end

# Create directory and JSON file
post '/*' do
end

# Change JSON file
# Commit changes to GIT
put '/*' do
end