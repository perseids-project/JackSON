require 'minitest'
require 'minitest/autorun'
require 'benchmark'
require 'rest_client'
require 'json'
require 'yaml'
require_relative '../lib/JackHELP.rb'

# Want to run a single test?
# You probably do when developing.
# ruby test_JackSON.rb --name test_AAA_post

class JackTEST < Minitest::Test
  
  # Big bold HTTP method constants
  
  POST = 'POST'
  GET = 'GET'
  PUT = 'PUT'
  DELETE = 'DELETE'
  
  # Config will be handy for testing
  
  @@settings = YAML.load( File.read("#{File.dirname(__FILE__)}/../JackSON.config.yml") )
  def self.settings
    @@settings
  end
  
  def self.test_order
    :alpha
  end
  

  # Helper methods
  
  private 
  
  def dir
    File.dirname(__FILE__)
  end
  
  def host
    "http://localhost:#{JackTEST.settings["port"]}"
  end
  
  def url( rel )
    "#{host}/data/#{rel}"
  end
  
  def urn_cite( urn )
    JSON.parse( RestClient.get "#{host}/urn?cite=#{urn}" )
  end
  
  def hashit( file )
    return {} if file == nil
    return JackHELP.run.hashit( "#{dir}/data/#{file}.json" )
  end
  
  def hashttp( file )
    { :data => hashit( file ) }
  end
  
  def api( method, file=nil, path )
    r = nil
    path = url( path )
    file = hashttp( file )
    case method.upcase
    when POST
      r = RestClient.post path, file
    when PUT
      r = RestClient.put path, file
    when GET
      r = RestClient.get path
    when DELETE
      r = RestClient.delete path
    end
    JSON.parse( r )
  end
  
  def success?( hash )
    hash.include?("success")
  end
  
end
