app.controller("controller", function( $scope, service ){
	
	// JackSON JSON URL
	$scope.url = 'apps/boilerplate/data'
	
	// Default data
	$scope.default = { name: "Your Data Here!" };

	// JSON Data model...
	// aka what gets saved to the JackSON server.
    $scope.data = angular.copy( $scope.default );
	
	// UI input
    $scope.form = {
        name: ""
    };
	
	// Messages
	$scope.msg = "";
	
	// Save!
	$scope.save = function() {
		$scope.data.name = $scope.form.name;
		service.save( $scope ).then(
			function( r ) { 
				$scope.msg = r;
			}
		)
	}
	
	// Start me up!
	start();
	function start() {
		service.start( $scope ).then(
			function( r ) { 
				$scope.data = r.data;
				$scope.msg = "Ready!"
			}
		);
	}
});