app.service( 'sparql', function( $http, $q ) {

	// Publicly accessible methods
	return ({
		search: search
	});
	
	// Update data on server
	function search( scope ) {
		var request = get( scope.config.query, scope.form.search );
		return( request.then( 
			function( r ) { return r.data  },
			function( r ){ return r }
		));
	}
	
	// JackSON wrapper
	function get( url, search ) {
		var query = url+'?query='+encodeURIComponent( search );
		return $http({
			method: 'GET',
			url: query,
		    headers: {
		        'Content-Type': 'application/json'
		    }
		});
	}
});