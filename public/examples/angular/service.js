app.service( 'service', function( $http, $q ) {
	// Publicly accessible methods
	return ({
		start: start,
		upd: upd,
		data: data,
		del: del
	});
	
	function start( json ) {
		var request = jackson( 'POST', json );
		return( request.then(
			function( r ) { return json }, 
			function( r ){ return data() } 
		));
	}
	
	function data() {
		var request = jackson( 'GET' );
		return( request.then( handSuc, handErr ) );
	}
	
	function del() {}

	function upd( json ) {
		var request = jackson( 'PUT', json );
		return( request.then( handSuc, handErr ) );
	}
	
	function jackson( method, json ) {
		return $http({
			method: method.toUpperCase(),
			url:'/data/angular/test/friends',
		    headers: {
		        'Content-Type': 'application/json'
		    },
			data: wrap( json )
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