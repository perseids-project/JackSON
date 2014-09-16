app.service( 'service', function( $http, $q ) {
	
	// Publicly accessible methods
	return ({
		start: start,
		save: save,
		data: data,
	});
	
	// Create a new JSON file if it doesn't already exist.
	function start( scope ) {
		var request = jackson( 'POST', scope.url, scope.data );
		return( request.then(
			function( r ) { return scope.data }, 
			function( r ){ return data( scope ) } 
		));
	}
	
	// Update data on server
	function save( scope ) {
		var request = jackson( 'PUT', scope.url scope.data );
		return( request.then( 
			handSuc, 
			handErr 
		));
	}
	
	// GET the JSON
	function data() {
		var request = jackson( 'GET', scope.url );
		return( request.then( 
			handSuc, 
			handErr 
		));
	}
	
	// JackSON wrapper
	function jackson( method, url, data ) {
		return $http({
			method: method.toUpperCase(),
			url: '/data/'+url,
		    headers: {
		        'Content-Type': 'application/json'
		    },
			data: wrap( data )
		});
	}
	
	// JackSON formatted json
	function wrap( json ) {
		return { data: { friends: json } }
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