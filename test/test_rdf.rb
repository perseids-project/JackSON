require_relative 'JackTEST.rb'

# Want to run a single test?
# You probably do when developing.
# ruby test_JackSON.rb --name test_AAA_post

class TestRDF < JackTEST
  
  # Create a brand new JSON file
  def test_AAA_post
    assert( false )
  end
  
  # PUT will change an existing JSON file
  def test_AAC_put
    assert( false )
  end
  
  # What you retrieve and what you start with should be the same
  def test_AAD_get
    assert( false )
  end
  
  def test_AAE_delete
    assert( false )
  end
    
end
