( function( global ) {
JackSON = function( url ) {
	if ( JackSON.prototype.me ) {
		return JackSON.prototype.me;
	}
	JackSON.prototype.me = this;
	this.url = ( url == undefined ) ? 'http://localhost:4567/data/' : url;
	this.json = null;
	this.result = null;
	
	/**
	 * Events
	 */
	this.events = {
		success: 'JackSON-SUCCESS',
		error: 'JackSON-ERROR'
	};
	
	/**
	 * HTTP PUT
	 */
	this.put = function( path, json ) {
		var self = this;
		$.ajax({
			type: "PUT",
			url: self.url+path,
			dataType: 'json',
			data: json,
			success: function( data ) {
				self.result = data;
				$( document ).trigger( self.events.success );
			},
			error: function() {
				$( document ).trigger( self.events.error );
			}
		});
	}
	
	/**
	 * HTTP POST
	 */
	this.post = function( path, json ) {
		var self = this;
		$.ajax({
			type: "POST",
			url: self.url+path,
			dataType: 'json',
			data: json,
			success: function( data ) {
				self.result = data;
				$( document ).trigger( self.events.success );
			},
			error: function() {
				$( document ).trigger( self.events.error );
			}
		});
	}
	
	/**
	 * HTTP GET
	 */
	this.get = function( path, json ) {
		var self = this;
		$.ajax({
			type: "GET",
			url: self.url+path,
			dataType: 'json',
			async: false,
			success: function( data ) {
				self.result = data;
				$( document ).trigger( self.events.success );
			},
			error: function() {
				$( document ).trigger( self.events.error );				
			}
		});
	}
};
} ( window ) );