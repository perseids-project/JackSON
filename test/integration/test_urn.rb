require_relative '../JackTEST.rb'

# Want to run a single test?
# You probably do when developing.

# ruby test_urn.rb --name test_AAA_urn

class TestUrn < JackTEST
  
  # Create a brand new JSON-LD file
  def test_AAA_urn
    r = api( POST, 'urn/elem/he', 'elem/he' )
    h = hashit( 'urn/elem/he' )
    r = urn( h['urn'] )
    puts h.inspect
    assert( true )
  end
    
end
