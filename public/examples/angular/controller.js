app.controller("controller", function( $scope, service ){

	// Model
    $scope.friends = [ "Me, Myself, and I" ];
	
	// UI input
    $scope.form = {
        name: ""
    };
	
	// UI only
	$scope.msg = "";
	
	// Add a new friend
	$scope.addFriend = function() {
		$scope.friends.push( $scope.form.name );
		service.upd( $scope.friends ).then(
			function( data ) { $scope.msg = "Saved Changes!"},
			function( data ) { $scope.msg = "Error Saving Changes!"}
		);
		$scope.form.name = "";
	}
	
	// Remove a friend
	$scope.removeFriend = function( friend ) {
		rm_in_array( $scope.friends, friend )
		service.upd( $scope.friends ).then(
			function( data ) { $scope.msg = "Saved Changes!"},
			function( data ) { $scope.msg = "Error Saving Changes!"}
		);
	}
	
	// Start it up
	start( $scope.friends );
	function start( json ) {
		service.start( json ).then(
			function( data ) { 
				$scope.friends = data.friends;
				$scope.msg = "Ready!"
			}
		);
	}
	
	// Remove matching items from array
	function rm_in_array( array, item ) {
		for ( var i = array.length - 1; i >= 0; i-- ) {
		    if ( array[i] === item ) {
				array.splice(i, 1);
			}
		}
	}
});