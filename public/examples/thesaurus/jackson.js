app.service( 'jackson', function( $http, $q ) {

	// Publicly accessible methods
	return ({
		save: save,
		gimme: gimme,
		destroy: destroy
	});
	
	// Update data on server
	function save( scope ) {
		var request = jackson( 'PUT', scope.save_url, scope.data );
		return( request.then( 
			function( r ) { return r.data.success  },
			function( r ){ return create( scope ) }
		));
	}
	
	function create( scope ) {
		var request = jackson( 'POST', scope.save_url, scope.data );
		return( request.then(
			function( r ) { return r.data.success },
			function( r ) { return r.data.error }
		));
	}
	
	function gimme() {
		var request = jackson( 'GET', scope.save_url, {} );
		return( request.then(
			function( r ) { return r.data },
			function( r ) { return r.data.error }
		));
	}
	
	function destroy() {
		var request = jackson( 'DELETE', scope.save_url, {} );
		return( request.then(
			function( r ) { return r.data.success },
			function( r ) { return r.data.error }
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