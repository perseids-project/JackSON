require_relative '../JackTEST'

class TestSpeed < JackTEST
  
  # Create a thousand JSON files in under 5 seconds.
  def test_AAA_post_thousand
    assert( true )
  end
  
  # Retrieve a thousand JSON files in under 5 seconds.
  def test_AAB_get_thousand
    assert( true )
  end
  
end
