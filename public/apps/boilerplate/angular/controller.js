app.controller("controller", function( $scope, json, sparql ){
	
	// Configuration
	$scope.config = {
		domain: location.protocol+'//'+location.hostname+(location.port ? ':' + location.port: '' ),
		app: 'boilerplate'
	}
	$scope.config.query = $scope.config.domain+'/query';
	
	// UI input
    $scope.form = {
    	name:"",
		symbol:"",
		weight:"",
		number:""
    };

	// What is saved to the JackSON server
    $scope.data = save_data();
	
	// The path of the specific JSON file
	$scope.path = "default"
	
	// Pretty print data for browser viewing
	$scope.pretty = angular.toJson( $scope.data, true );
	
	// Configuration table
	$scope.app_root = app_root();
	$scope.save_url = save_url();
	
	// Search
	$scope.search = query();
	
	// Messages
	$scope.msg = "Welcome!";

	// Save the data
	$scope.save = function() {
		$scope.form_apply();
		$scope.refresh();
		json.post( $scope ).then(
			function( msg ) { 
				$scope.msg = msg;
			}
		)
	}
	
	// Open saved data on load
	$scope.open = function() {
		json.get( $scope ).then(
			function( data ) {
				$scope.data = data;
				$scope.data_to_form();
				$scope.refresh();
			}
		)
	}
	$scope.open();
	
	// Update schtuff
	$scope.refresh = function() {
		$scope.save_url = save_url();
		$scope.search = query();
		$scope.pretty = angular.toJson( $scope.data, true );
	}
	
	// Apply form data
	$scope.form_apply = function() {
		$scope.data = save_data();
	}
	
	// Take JSON data and apply it to the form
	$scope.data_to_form = function() {
		for ( var key in $scope.data ) {
			if ( key == '@context' ) { continue }
			$scope.form[key] = $scope.data[key]
		}
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
				"name": app_root()+"/spec.html#name",
			},
			"name": $scope.form.name,
			"symbol": $scope.form.symbol,
			"weight": $scope.form.weight,
			"number": $scope.form.number,
		};
	}
	
	// Return this application's root url
	function app_root() {
		return document.URL.replace(/\/$|\/index\.html.*/,'');
	}
	
	// Return the data url for the app
	function app_data_url() {
		var c = $scope.config
		return c.domain+'/data/'+c.app;
	}
	
	// Get the JackSON server save url
	function save_url() {
		return app_data_url()+'/'+$scope.path;
	}
	
	// Dynamic SPARQL query
	function query() {
		return "SELECT ?p ?o WHERE { <"+save_url()+"> ?p ?o }"
	}
});