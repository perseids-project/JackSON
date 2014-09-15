app.controller("controller", function( $scope, $http ){
	
	$scope.get = function() {}
	
	$scope.update = function() {
		
		// JackSON requires 'data' key.
		var json = {
			data: {
				angular: $scope.word
			},
			_method: "put"
		};

		var request = $http({
			method:'PUT',
			url:'/data/angular/test',
		    headers: {
		        'Content-Type': 'application/json'
		    },
			data: json
		});
		
		request.success(
			function(){
				console.log( "yes" );
			}
		);
	}
});