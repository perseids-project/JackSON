app.controller("controller", function( $scope, jackson ){
	
	// PROPERTIES
	
	// JackSON JSON URL
	$scope.config = {
		domain: location.protocol+'//'+location.hostname+(location.port ? ':'+location.port: ''),
		app: 'examples/thesaurus',
		sparql: 'http://127.0.0.1:4321/ds'
	}
	$scope.word = '';
	$scope.examples = [];
	$scope.syns = [];

	// What is saved to the JackSON server.
    $scope.data = save_data();
	
	// Pretty print data for browser viewing.
	$scope.pretty = angular.toJson( $scope.data, true );
	
	// UI input
    $scope.form = {
    	word: "",
		example: "",
		syn: "",
		search: "select ?s ?p ?o where { ?s ?p ?o }"
    };
	
	// Configuration table
	$scope.app_url = app_url();
	$scope.save_url = save_url();
	$scope.database = database();
	
	// Messages
	$scope.msg = "Welcome!";


	// METHODS
	
	// word change
	$scope.change_word = function() {
		$scope.word = $scope.form.word;
		refresh();
	}
	
	// examples
	$scope.addExample = function() {
		var fe = $scope.form.example;
		var exs = $scope.examples;
		if ( in_array( exs, fe ) == false ) {
			exs.push( fe );
			refresh();
			return;
		}
		$scope.msg = "example exists";
	}
	
	$scope.removeExample = function( example ) {
		rm_in_array( $scope.examples, example );
		refresh();
	}
	
	// synonyms
	$scope.addSyn = function() {
		var fs = database()+"/"+$scope.form.syn;
		var s = $scope.syns;
		if ( in_array( s, fs ) == false ) {
			s.push( fs );
			refresh();
			return;
		}
		$scope.msg = "synonym exists";
	}
	
	$scope.removeSyn = function( synonym ) {
		rm_in_array( $scope.syns, synonym );
		refresh();
	}
	
	// save the data.
	$scope.save = function() {
		jackson.save( $scope ).then(
			function( msg ) { 
				$scope.msg = msg;
			}
		)
	}
	
	// get a json file.
	$scope.gimme = function( url ) {
		jackson.gimme( url ).then(
			function( data ) {
				console.log( data );
			}
		)
	}
	
	
	$scope.clear = function() {
		$scope.word = '';
		$scope.examples = [];
		$scope.syns = [];
		for ( var key in $scope.form ) {
			$scope.form[key] = '';
		}
		refresh();
	}
	
	function save_data() {
		return { 
			"@context": {
				"word": app_url()+"/spec.html#word",
				"examples": app_url()+"/spec.html#example",
				"syns": {
					"@id": app_url()+"/spec.html#synonym",
					"@type": "@id"
				}
			},
			"word": $scope.word,
			"examples": $scope.examples,
			"syns": $scope.syns
		};
	}
	
	function refresh() {
		$scope.save_url = save_url();
		$scope.data = save_data();
		$scope.pretty = angular.toJson( $scope.data, true );
	}
	
	// Return this application's url
	function app_url() {
		return document.URL;
	}
	
	// Return JackSON data url
	function database() {
		var c = $scope.config
		return c.domain+'/data/'+c.app;
	}
	
	function save_url() {
		var c = $scope.config
		return database()+'/'+$scope.word;
	}
	
	// Remove matching items from array
	function rm_in_array( array, item ) {
		for ( var i = array.length - 1; i >= 0; i-- ) {
		    if ( array[i] === item ) {
				array.splice(i, 1);
			}
		}
	}
	
	function in_array( array, item ) {
		for ( var i = array.length - 1; i >= 0; i-- ) {
		    if ( array[i] === item ) {
				return true;
			}
		}
		return false;
	}
});