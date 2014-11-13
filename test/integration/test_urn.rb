require_relative '../JackTEST'

# Want to run a single test?
# You probably do when developing.

# ruby test_urn.rb --name test_AAA_urn

class TestUrn < JackTEST
  
  # Create a new JSON-LD file and retrieve it by URN
  def test_AAA_urn
    r = api( POST, 'urn/elem/he', 'elem/he' )
    h = hashit( 'urn/elem/he' )
    r = urn_cite( h['urn'] )
    assert( r == h )
  end
  
  def test_AAB_urn_rdf
    
  end
  
  def test_AAB_urn_rdf_delete
    
  end
   
end
