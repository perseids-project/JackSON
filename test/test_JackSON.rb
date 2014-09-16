require 'minitest/autorun'
require 'benchmark'
require 'rest_client'
require 'json'
require_relative '../JackHELP.rb'

# Want to run a single test?
# You probably do when developing.
# ruby test_JackSON.rb --name test_check

class TestJackSON < Minitest::Test
  
  # Big bold HTTP method constants.
  # Better reminders?
  POST = 'POST'
  GET = 'GET'
  PUT = 'PUT'
  DELETE = 'DELETE'
  
  def self.test_order
    :alpha
  end
  
  # The actual tests!
  def test_AAA_post
    api( POST, url('test/data'), hashit('json/foo_bar') )
    assert( 1, 1 )
  end
  
  def test_AAB_post_dupe
    api( POST, url('test/data'), hashit('json/foo_blank') )
    assert( 1, 1 )
  end
  
  def test_AAC_put
    api( PUT, url('test/data'), hashit('json/foo_blank') )
    assert( 1, 1 )
  end
  
  def test_AAD_get
    response = api( GET, url('test/data') )
    assert( 1, 1 )
  end
  
  def test_AAE_delete
    api( DELETE, url('test/data') )
    assert( 1, 1 )
  end
  
  # Helper methods.
  private 
  
  def url( rel )
    "http://localhost:4567/data/#{rel}"
  end
  
  def hashit( path )
    file = JackHELP.run.json_file( File.dirname(__FILE__), path )
    return { :data => JSON.parse( File.read( file ) ) }
  end
  
  def api( method, path, hash=nil )
    case method.upcase
    when POST
      RestClient.post url(path), hash
    when PUT
      RestClient.put url(path), hash
    when GET
      RestClient.get url(path)
    when DELETE
      RestClient.delete url(path), hash
    end
  end
  
end
