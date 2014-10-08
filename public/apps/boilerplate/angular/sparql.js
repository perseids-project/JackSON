app.service( 'sparql', function( $http, $q ) {

	// Publicly accessible methods
	return ({
		search: search
	});
	
	// Update data on server
	function search( scope ) {
		var request = sparql( 'PUT', scope.config.sparql );
		return( request.then( 
			function( r ) { return r.data.success  },
			function( r ){ return create( scope ) }
		));
	}
	
	// JackSON wrapper
	function sparql( url, data ) {
		return $http({
			method: 'GET',
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