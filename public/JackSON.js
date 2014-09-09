( function( global ) {
JackSON = function( url ) {
	if ( JackSON.prototype.me ) {
		return JackSON.prototype.me;
	}
	JackSON.prototype.me = this;
	this.url = ( url == undefined ) ? 'http://localhost:4567/data/' : url+'/data/';
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
	 * Build the message_box
	 */
	this.message_box = function() {
		var self = this;
		console.log( 'message_box' );
	}
	
	/**
	 * HTTP PUT
	 */
	this.put = function( path, json ) {
		var self = this;
		$.ajax({
			type: "POST",
			url: self.url+path,
			dataType: 'json',
			data: {"data": json, "_method": 'PUT' },
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
			data: {"data": json },
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
	 * HTTP DELETE
	 */
	this.delete = function( path ) {
		var self = this;
		$.ajax({
			type: "POST",
			url: self.url+path,
			dataType: 'json',
			data: {"_method": "DELETE" },
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
	this.get = function( path ) {
		var self = this;
		$.ajax({
			type: "GET",
			url: self.url+path,
			dataType: 'json',
			success: function( data ) {
				self.result = data;
				self.json = data;
				$( document ).trigger( self.events.success );
			},
			error: function() {
				$( document ).trigger( self.events.error );				
			}
		});
	}
	
	// Build the message box
	this.message_box();
};
} ( window ) );