app.controller("controller", function( $scope, json ){
	
	// JackSON JSON URL
	$scope.url = 'apps/boilerplate/data'
	
	// Default data
	$scope.default = { name: "Your Data Here!" };

	// JSON Data model...
	// aka what gets saved to the JackSON server.
    $scope.data = angular.copy( $scope.default );
	
	// Pretty print data for browser viewing.
	$scope.pretty = angular.toJson( $scope.data, true );
	
	// UI input
    $scope.form = {
		name: "",
		search: "select ?s ?p ?o where { ?s ?p ?o }"
    };
	
	// Messages
	$scope.msg = "";
	
	// Save!
	$scope.save = function() {
		$scope.data.name = $scope.form.name;
		json.save( $scope ).then(
			function( r ) { 
				$scope.msg = r;
			}
		)
	}
	
	// Start me up!
	start();
	function start() {
		json.start( $scope ).then(
			function( r ) { 
				$scope.data = r.data;
				$scope.msg = "Ready!"
			}
		);
	}
});