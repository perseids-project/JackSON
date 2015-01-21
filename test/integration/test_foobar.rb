require_relative '../JackTEST'

# Test of the most basic PUT POST GET DELETE functionality.
# RESTful API basics.

class TestFoobar < JackTEST
  
  
  # Create a brand new JSON file
  
  def test_post
    destroy_data()
    r = api( POST, 'foo_bar', 'foo/bar' )
    assert( success?(r) )
  end
  
  
  # Can't POST if JSON file exists at url
  
  def test_post_dupe
    destroy_data()
    check = false
    
    # Error should be raised
    
    begin
      api( POST, 'foo_blank', 'foo/bar' )
      api( POST, 'foo_blank', 'foo/bar' )
    rescue
      check = true
    end
    assert( check )
  end
  
  
  # PUT will change an existing JSON file
  
  def test_put
    destroy_data()
    api( POST, 'foo_blank', 'foo/bar' )
    r = api( PUT, 'foo_blank', 'foo/bar' )
    assert( success?(r) )
  end
  
  
  # What you retrieve and what you start with should be the same
  
  def test_get
    destroy_data()
    api( POST, 'foo_blank', 'foo/bar' )
    r = api( GET, nil, 'foo/bar' )
    j = hashit('foo_blank')
    check = false;
    if j == r
      check = true;
    end
    assert( check )
  end
  
  
  # Make sure you can delete
  
  def test_delete
    destroy_data()
    api( POST, 'foo_blank', 'foo/bar' )
    r = api( DELETE, nil, 'foo/bar' )
    assert( success?(r) )
  end
    
end
