app.controller("controller", function( $scope, $http ){
	
	$scope.json = function() {
		return { 
			data: {
				angular: $scope.word
			}
		}
	}
	
	$scope.get = function() {}
	
	$scope.update = function() {

		var request = $http({
			method:'PUT',
			url:'/data/angular/test',
		    headers: {
		        'Content-Type': 'application/json'
		    },
			data: $scope.json()
		});
		
		request.success(
			function(){
				console.log( "yes" );
			}
		);
	}
	
	
});