app.controller("controller", function( $scope, json, sparql ){
	
	// Configuration
	$scope.config = {
		domain: location.protocol+'//'+location.hostname+(location.port ? ':' + location.port: '' ),
		app: 'boilerplate'
	}
	$scope.config.query = $scope.config.domain+'/query';
	
	// UI input
    $scope.form = {
    	name: "",
    };

	// What is saved to the JackSON server
    $scope.data = save_data();
	
	// Pretty print data for browser viewing
	$scope.pretty = angular.toJson( $scope.data, true );
	
	// Configuration table
	$scope.app_url = app_url();
	$scope.save_url = save_url();
	
	// Search
	$scope.search = "select ?s ?p ?o where { ?s ?p ?o }"
	
	
	// Messages
	$scope.msg = "Welcome!";

	// Save the data
	$scope.save = function() {
		$scope.refresh();
		json.post( $scope ).then(
			function( msg ) { 
				$scope.msg = msg;
			}
		)
	}
	
	// Open saved data on load
	$scope.open = function() {
		console.log( 'Write this!' );
	}
	$scope.open();
	
	
	// Update with form data
	$scope.refresh = function() {
		$scope.save_url = save_url();
		$scope.data = save_data();
		$scope.pretty = angular.toJson( $scope.data, true );
	}
	
	// Sparql query
	$scope.query = function() {
		sparql.search( $scope ).then(
			function( data ) {
				$scope.sparql_json = angular.toJson( data, true );
			}
		);
	}
	
	// Save JSON data to JackSON server
	function save_data() {
		return { 
			"@context": {
				"name": app_url()+"/spec.html#name",
			},
			"name": $scope.form.name,
		};
	}
	
	// Return this application's url
	function app_url() {
		return document.URL;
	}
	
	// Return the data url for the app
	function app_data_url() {
		var c = $scope.config
		return c.domain+'/data/'+c.app;
	}
	
	// Get the JackSON server save url
	function save_url() {
		return app_data_url();
	}
});