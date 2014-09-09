( function( global ) {
JackSON = function( url ) {
	if ( JackSON.prototype.me ) {
		return JackSON.prototype.me;
	}
	JackSON.prototype.me = this;
	this.url = ( url == undefined ) ? 'http://localhost:4567' : url;
	this.json = null;
	this.result = null;
	
	/**
	 * Events
	 */
	this.events = {
		success: 'JackSON-SUCCESS',
		error: 'JackSON-ERROR',
		send: 'JackSON-SEND'
	};
	
	/**
	 * Build the flash message box
	 */
	this.flash = function() {
		var self = this;
		$( 'body' ).append( '\
			<div id="jackson_flash">\
				<img class="loader" src="'+this.url+'/loader.gif" />\
				<div class="msg"></div>\
			</div>\
		');
		$( '#jackson_flash' ).css({
			'box-sizing': 'border-box',
			'overflow-y': 'hidden',
			'transition': 'all 1s',
			'-webkit-transition': 'all 1s',
			'position': 'fixed',
			'top': 0,
			'left': 0,
			'background-color': '#DDD',
			'height': 0,
			'width': '100%'
		});
		$( '#jackson_flash img' ).css({
			'float': 'left',
			'margin': '2px 4px 2px 2px'
		});
		$( '#jackson_flash .msg' ).css({
			'margin': '5px'
		});
	}
	
	/**
	 * Flash a message
	 */
	this.msg = function( state, msg ) {
		$( '#jackson_flash .msg' ).text( msg );
		$( '#jackson_flash img' ).hide();
		switch( state ) {
			case 'SUCCESS':
				$( '#jackson_flash' ).css({ 'background-color': '#AAFFAA' });
				this.fade();
				break;
			case 'ERROR':
				$( '#jackson_flash' ).css({ 'background-color': '#FFAAAA' });
				this.fade();
				break;
			case 'SEND':
				$( '#jackson_flash img' ).show();
				break;
		}
		$( '#jackson_flash' ).css({ 'height': '32px' });
	}
	
	/**
	 * Fadeout the message
	 */
	this.fade = function() {
		setTimeout( function() {
			$( '#jackson_flash' ).css({ 
				'height': 0,
				'background-color': '#DDD'
			});
		}, 4000 );
	}
	
	/**
	 * Construct the json data path
	 */
	this.data_path = function( path ) {
		return this.url+'/data/'+path;
	}
	
	/**
	 * HTTP PUT
	 */
	this.put = function( path, json ) {
		var self = this;
		$( document ).trigger( self.events.send );
		self.msg( 'SEND', 'PUT' );
		$.ajax({
			type: "POST",
			url: self.data_path( path ),
			dataType: 'json',
			data: {"data": json, "_method": 'PUT' },
			success: function( data ) {
				self.result = data;
				self.msg( 'SUCCESS', data.success );
				$( document ).trigger( self.events.success );
			},
			error: function( req, stat, err ) {
				self.error( req, stat, err );
			}
		});
	}
	
	/**
	 * HTTP POST
	 */
	this.post = function( path, json ) {
		var self = this;
		$( document ).trigger( self.events.send );
		self.msg( 'SEND', 'POST' );
		$.ajax({
			type: "POST",
			url: self.data_path( path ),
			dataType: 'json',
			data: {"data": json },
			success: function( data ) {
				self.result = data;
				self.msg( 'SUCCESS', data.success );
				$( document ).trigger( self.events.success );
			},
			error: function( req, stat, err ) {
				self.error( req, stat, err );
			}
		});
	}
	
	/**
	 * HTTP DELETE
	 */
	this.delete = function( path ) {
		var self = this;
		$( document ).trigger( self.events.send );
		self.msg( 'SEND', 'DELETE' );
		$.ajax({
			type: "POST",
			url: self.data_path( path ),
			dataType: 'json',
			data: {"_method": "DELETE" },
			success: function( data ) {
				self.result = data;
				self.msg( 'SUCCESS', data.success );
				$( document ).trigger( self.events.success );
			},
			error: function( req, stat, err ) {
				self.error( req, stat, err );
			}
		});
	}
	
	/**
	 * HTTP GET
	 */
	this.get = function( path ) {
		var self = this;
		$( document ).trigger( self.events.send );
		self.msg( 'SEND', 'GET' );
		$.ajax({
			type: "GET",
			url: self.data_path( path ),
			dataType: 'json',
			success: function( data ) {
				self.result = data;
				self.json = data;
				self.msg( 'SUCCESS', path+' retrieved!' );
				$( document ).trigger( self.events.success );
			},
			error: function( req, stat, err ) {
				self.error( req, stat, err );
			}
		});
	}
	
	/**
	 * Display an error message
	 */
	this.error = function( req, stat, err ) {
		var msg = '';
		err = err.toUpperCase();
		try {
			msg = JSON.parse( req.responseText );
			err += ': ' + msg.error;
			this.msg( 'ERROR', err );
		}
		catch( e ) {
			err += ': ' + e;
			this.msg( 'ERROR', err );
		}
		$( document ).trigger( self.events.error );
	}
	
	// Build the message box
	this.flash();
};
} ( window ) );