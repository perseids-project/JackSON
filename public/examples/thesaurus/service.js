app.service( 'service', function( $http, $q ) {

	// Publicly accessible methods
	return ({
		save: save,
	});
	
	// Update data on server
	function save( scope ) {
		var request = jackson( 'PUT', scope.save_url, scope.data );
		return( request.then( 
			function( r ) { scope.msg = r.data; return r.data  },
			function( r ){ return create( scope ) }
		));
	}
	
	function create( scope ) {
		var request = jackson( 'POST', scope.save_url, scope.data );
		return( request.then(
			function( r ) { scope.msg = r.data; return r.data  },
			function( r ) { scope.msg = r.data; return r.data  }
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
});