require 'test/unit'
require 'benchmark'
require 'rest_client'
class TestJackSON < Test::Unit::TestCase
  
  def test_post
    RestClient.post 'http://localhost:4567/data/test/data.json', { :foo => 'bar' }
    assert( 1, 1 )
  end
  
  def test_put
    RestClient.put 'http://localhost:4567/data/test/data.json', { :foo => 'buzz' }
    assert( 1, 1 )
  end
  
end