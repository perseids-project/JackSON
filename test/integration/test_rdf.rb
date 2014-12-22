require_relative '../JackTEST'

# Want to run a single test?
# You probably do when developing.

# ruby test_rdf.rb --name test_AAB_post_extra
# ruby test_rdf.rb --name test_AAC_post_list
# ruby test_rdf.rb --name test_AAD_post_id

class TestRDF < JackTEST
  
  # Create a brand new JSON-LD file
  def test_AAA_post
    r = api( POST, 'ld', 'rdf/ld' )
    assert( true )
  end
  
  def test_AAB_post_extra
    r = api( POST, 'ld_extra', 'rdf/ld_extra' )
    assert( true )
  end
  
  def test_AAC_post_list
    r = api( POST, 'ld_list', 'rdf/ld_list' )
    assert( true )
  end
    
end
