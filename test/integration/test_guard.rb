require_relative '../JackTEST'

# Want to run a single test?
# You probably do when developing.

# ruby test_dir_conf.rb --name test_AAA_post

class TestGuard < JackTEST
  
  def test_AAA_post
    r = api( POST, 'foo_bar', 'guard/test' )
    puts r.inspect
    assert( success?(r) )
  end
  
  def test_AAB_put
    r = api( PUT, 'foo_bar', 'guard/test' )
    puts r.inspect
    assert( success?(r) )
  end
      
end
