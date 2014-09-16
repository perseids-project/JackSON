require 'test/unit'
require 'benchmark'
require 'rest_client'
class TestJackSON < Test::Unit::TestCase
  
  def test_post
    RestClient.post p.ath('test/data'), { :foo => 'bar' }
    assert( 1, 1 )
  end
  
  def test_post_dupe
    RestClient.post 'test/data', { :foo => 'blank' }
    assert( 1, 1 )
  end
  
  def test_put
    RestClient.put 'test/data', { :foo => 'buzz' }
    assert( 1, 1 )
  end
  
  def test_get
    response = RestClient.get 'test/data'
    response.to_str
    assert( 1, 1 )
  end
  
  def test_delete
    RestClient.delete 'test/data'
    assert( 1, 1 )
  end
  
end

class j
  
  def self.son
    
  end
  
end

class p
  def self.ath( rel )
    "http://localhost:4567/data#{rel}"
  end
end
