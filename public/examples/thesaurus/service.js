app.service( 'service', function( $http, $q ) {

	// Publicly accessible methods
	return ({
		save: save,
	});
	
	// Update data on server
	function save( scope ) {
		var request = jackson( 'PUT', scope.save_url, scope.data );
		return( request.then( 
			handSuc, 
			function(){ create( scope ) }
		));
	}
	
	function create( scope ) {
		var request = jackson( 'POST', scope.save_url, scope.data );
		return( request.then(
			handSuc,
			handErr
		));
	}
	
	// JackSON wrapper
	function jackson( method, url, data ) {
		return $http({
			method: method.toUpperCase(),
			url: url,
		    headers: {
		        'Content-Type': 'application/json'
		    },
			data: wrap( data )
		});
	}
	
	// JackSON formatted json
	function wrap( json ) {
		return { data: json }
	}
	
	// Error handler
	function handErr( r ) {
		if (
			! angular.isObject( r.data ) ||
			! r.data.message
		) {
			return( $q.reject( "An unknown error occurred." ) );
		}
		return( $q.reject( r.data.message ) );
	}

	// Success handler	
	function handSuc( r ) {
		return( r.data );
	}
});