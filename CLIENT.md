# How to JackSON.js

Open your Javascript console and play along!

## Create a JackSON API object
	var jack = new JackSON();

By default the JackSON.js will communicate with the JackSON server accessible at [http://localhost:4567](http://localhost:4567)

If your JackSON server is elsewhere remember to pass the new address when creating the API object.

	var jack = new JackSON( "http://my.doma.in/jackson" )

## Methods
JackSON API method calls are asynchronous, so you have to listen for success and error events.

	$( document ).on( jack.events.success, function( e ) {
		console.log( jack.result );
	});
	$( document ).on( jack.events.error, function( e ) {
		console.log( jack.result );
	});

### .post( url, json ) -- Create a new JSON file
	jack.post( 'path/to/json/file', { "foo": "bar" } );

You can always add .json to the url of any JackSON method.

	jack.post( 'path/to/json/file.json', { "foo": "bar" } );

This maps the the same JSON file as the line above.

Only use post() when creating a new JSON file.

### .put( url, json ) -- Update a JSON file
	jack.put( 'path/to/json/file', { "foo": "buzz" } );

Only use put() to update an existing JSON file.

### .get( url ) -- Retrieve a JSON file
	jack.get( 'path/to/json/file' );

The last successfully retrieved JSON file by get() is stored like so...

	var json = jack.json;

### .delete( url ) -- Delete a JSON file
	jack.delete( 'path/to/json/file' );