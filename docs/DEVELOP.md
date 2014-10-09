# Help develop JackSON!
If you dig this project and want to contribute... thank you, and read on!

## Preferred Development Process
* GitHub fork
* write feature's unit tests
* write feature
* run feature's unit tests
	* pass!
		* run full test suite
			* pass!
				* send pull request through GitHub
			* fail...
				* try again!
	* fail...
		* fix feature!

# Testing
Test files go in...

	test/

Unit tests are for testing modules independently from JackSON's sinatra server. They go in...

	test/unit

Integration tests are for testing JackSON's sinatra server methods using an HTTP client.  They go in...

	test/integration

JSON used by tests go in...

	test/data/

JSON validators used by tests go in..

	test/validate

Naming convention can be summed-up as:

	test/[unit or integration]/test_group.rb
	class TestGroup < JackTEST

An example test file:

	require_relative 'JackTEST.rb'
	class TestGroup < JackTEST
	
	  def test_AAA_post
	    r = api( POST, 'test/data', 'json/foo_bar' )
	    assert( success?(r) )
	  end
	  
	  def test_AAB_put
	    r = api( PUT, 'test/data', 'json/foo_bar' )
	    assert( success?(r) )
	  end
	  
    end
