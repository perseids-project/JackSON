# Help develop JackSON
JackSON's preferred development and contribution procedure:

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

JSON samples used by tests go in...

	test/json/

Naming convention can be summed-up as:

	test/test_group.rb
	test/json/group.json

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
