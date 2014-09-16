require_relative 'JackTEST.rb'

# Want to run a single test?
# You probably do when developing.
# ruby test_JackSON.rb --name test_AAA_post

class TestFoobar < JackTEST
  
  # Create a brand new JSON file
  def test_AAA_post
    r = api( POST, 'test/data', 'json/foo_bar' )
    assert( success?(r) )
  end
  
  # Can't POST if JSON file exists at url
  def test_AAB_post_dupe
    check = false
    begin
      api( POST, 'test/data', 'json/foo_blank' )
    rescue
      check = true
    end
    assert( check )
  end
  
  # PUT will change an existing JSON file
  def test_AAC_put
    r = api( PUT, 'test/data', 'json/foo_blank' )
    assert( success?(r) )
  end
  
  # What you retrieve and what you start with should be the same
  def test_AAD_get
    check = false;
    r = api( GET, 'test/data' )
    j = hashit('json/foo_blank')
    if j == r
      check = true;
    end
    assert( check )
  end
  
  def test_AAE_delete
    r = api( DELETE, 'test/data' )
    assert( success?(r) )
  end
    
end
