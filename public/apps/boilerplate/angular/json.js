app.service( 'json', function( $http, $q ) {
	
	// Publicly accessible methods
	return ({
		post: post,
		put: put,
		get: get,
	});
	
	// Create a new JSON file if it doesn't already exist.
	function post( scope ) {
		var request = api( 'POST', scope.save_url, scope.data );
		return( request.then(
			handSuc, 
			function( r ){ return put( scope ) } 
		));
	}
	
	// Update data on server
	function put( scope ) {
		var request = api( 'PUT', scope.save_url, scope.data );
		return( request.then( 
			handSuc, 
			handErr 
		));
	}
	
	// GET the JSON
	function get( scope ) {
		var request = api( 'GET', scope.save_url );
		return( request.then( 
			handSuc, 
			handErr 
		));
	}
	
	// API
	function api( method, url, data ) {
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