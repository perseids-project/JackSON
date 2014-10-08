app.controller("controller", function( $scope, json ){
	
	// PROPERTIES
	
	// JackSON JSON URL
	$scope.config = {
		domain: location.protocol+'//'+location.hostname+(location.port ? ':'+location.port: ''),
		app: 'apps/boilerplate',
		sparql: 'http://127.0.0.1:4321/ds'
	}
	
	// UI input
    $scope.form = {
    	name: "",
		search: "select ?s ?p ?o where { ?s ?p ?o }"
    };

	// What is saved to the JackSON server.
    $scope.data = save_data();
	
	// Pretty print data for browser viewing.
	$scope.pretty = angular.toJson( $scope.data, true );
	
	// Configuration table
	$scope.app_url = app_url();
	$scope.save_url = save_url();
	$scope.database = database();
	
	// Messages
	$scope.msg = "Welcome!";

	// METHODS
	
	// save the data.
	$scope.save = function() {
		json.save( $scope ).then(
			function( msg ) { 
				$scope.msg = msg;
			}
		)
	}
	
	function save_data() {
		return { 
			"@context": {
				"name": app_url()+"/spec.html#name",
			},
			"name": $scope.form.name,
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
		return database();
	}
});