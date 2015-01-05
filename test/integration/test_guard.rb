require_relative '../JackTEST'

# Want to run a single test?
# You probably do when developing.

# ruby test_guard.rb --name test_AAA_put_good

class TestGuard < JackTEST
  
  def test_AAA_post_good
    r = api( POST, 'guard/good', 'guard/test' )
    assert( success?(r) )
  end
  
  def test_AAB_put_good
    r = api( PUT, 'guard/good', 'guard/test' )
    assert( success?(r) )
  end
  
  def test_AAC_post_bad
    r = api( POST, 'guard/bad', 'guard/test' )
    assert( success?(r) )
  end
  
  def test_AAD_put_bad
    r = api( PUT, 'guard/bad', 'guard/test' )
    assert( success?(r) )
  end
      
end
