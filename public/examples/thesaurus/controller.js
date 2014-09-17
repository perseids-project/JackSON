app.controller("controller", function( $scope, service ){
	
	// JackSON JSON URL
	$scope.config = {
		domain: location.protocol+'//'+location.hostname+(location.port ? ':'+location.port: ''),
		app: 'examples/thesaurus'
	}
	$scope.word = 'default';
	
	// Default data
	// This is where you'll build your data-model
	$scope.default = { 
		"@context": {
			"word": app_url()+"/spec.html#word",
			"examples": app_url()+"/spec.html#example",
			"synonyms": {
				"@id": app_url()+"/spec.html#synonym",
				"@type": "@id"
			}
		},
		"word": $scope.word,
		"examples": [],
		"synonyms": [],
	};

	// What gets saved to the JackSON server.
    $scope.data = angular.copy( $scope.default );
	
	// UI input
    $scope.form = {
    	word: ""
    };
	
	$scope.app_url = app_url();
	$scope.save_url = save_url();
	$scope.database = database();
	
	// Messages
	$scope.msg = "";
	
	// Scope functions
	// Change the word!
	$scope.change_word = function() {
		$scope.word = $scope.form.word;
		$scope.save_url = save_url();
	}
	
	// Save!
	$scope.save = function() {
		$scope.data.name = $scope.form.name;
		service.save( $scope ).then(
			function( r ) { 
				$scope.msg = r;
			}
		)
	}
	
	// Return this application's url
	function app_url() {
		var c = $scope.config;
		return c.domain+'/'+c.app;
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
	
	// Start me up!
	start();
	function start() {
		/*
		service.start( $scope ).then(
			function( r ) { 
				$scope.data = r.data;
				$scope.msg = "Ready!"
			}
		);
		*/
	}
});