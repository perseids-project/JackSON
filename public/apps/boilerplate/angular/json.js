app.service( 'json', function( $http, $q ) {
	
	// Publicly accessible methods
	return ({
		post: post,
		put: put,
		get: get,
		ls: ls,
		urn: urn
	});
	
	// Retrieve a JSON file by URN
	function urn( scope ) {
		var request = api( 'GET', scope.urn_url );
		return( request.then( 
			success, 
			error 
		));
	}
	
	// Create a new JSON file if it doesn't already exist.
	function post( scope ) {
		var request = api( 'POST', scope.save_url, scope.data );
		return( request.then(
			success, 
			function( r ){ return put( scope ) } 
		));
	}
	
	// Update data on server
	function put( scope ) {
		var request = api( 'PUT', scope.save_url, scope.data );
		return( request.then( 
			success, 
			error 
		));
	}
	
	// GET the JSON
	function get( scope ) {
		var request = api( 'GET', scope.save_url );
		return( request.then( 
			success, 
			error 
		));
	}
	
	// Run the ls command
	function ls( scope ) {
		var request = api( 'GET', scope.save_dir+"?cmd=ls" );
		return( request.then(
			success,
			error
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
	function error( r ) {
		if (
			! angular.isObject( r.data ) ||
			! r.data.error
		) {
			var unknown = "An unknown error occurred."
			return( $q.reject( unknown ) );
		}
		return( r.data );
	}

	// Success handler	
	function success( r ) {
		return( r.data );
	}
});