require_relative '../JackTEST'

# Want to run a single test?
# You probably do when developing.

# ruby test_foobar.rb --name test_AAA_post

class TestFoobar < JackTEST
  
  # Create a brand new JSON file
  def test_AAA_post
    r = api( POST, 'foo_bar', 'foo/bar' )
    assert( success?(r) )
  end
  
  # Can't POST if JSON file exists at url
  def test_AAB_post_dupe
    check = false
    begin
      api( POST, 'foo_blank', 'foo/bar' )
    rescue
      check = true
    end
    assert( check )
  end
  
  # PUT will change an existing JSON file
  def test_AAC_put
    r = api( PUT, 'foo_blank', 'foo/bar' )
    assert( success?(r) )
  end
  
  # What you retrieve and what you start with should be the same
  def test_AAD_get
    check = false;
    r = api( GET, nil, 'foo/bar' )
    j = hashit('foo_blank')
    if j == r
      check = true;
    end
    assert( check )
  end
  
  def test_AAE_delete
    r = api( DELETE, nil, 'foo/bar' )
    assert( success?(r) )
  end
    
end
