# How to JackSON.js

Open your Javascript console and play along!

## Create a JackSON API object
	var jack = new JackSON();

By default the JackSON.js will communicate with the JackSON server accessible at [http://localhost:4567](http://localhost:4567)

If your JackSON server is elsewhere remember to pass its address in a config object when creating the API object...

	var jack = new JackSON({ url: "http://my.doma.in/jackson" })

## Methods
JackSON API method calls are asynchronous, so you have to listen for success and error events...

	$( document ).on( jack.events.success, function( e ) {
		console.log( jack.result );
	});
	$( document ).on( jack.events.error, function( e ) {
		console.log( jack.result );
	});

### .post( url, json ): Create a new JSON file
	jack.post( 'path/to/json/file', { "foo": "bar" } );

You can always add .json to the url of any JackSON method...

	jack.post( 'path/to/json/file.json', { "foo": "bar" } );

This maps to the same JSON file as the line above.

You can only use .post() to create a new JSON file.
Passing an existing JSON file url to .post() will throw an error.

### .put( url, json ): Update a JSON file
	jack.put( 'path/to/json/file', { "foo": "buzz" } );

.put() will only update exisitng JSON files.

### .get( url ): Retrieve a JSON file
	jack.get( 'path/to/json/file' );

The last JSON file successfully retrieved by .get() is stored like so...

	var json = jack.json;

Remember the API calls are asynchronous, so all together you'd need...

	$( document ).on( jack.events.success, function( e ) {
		var json = jack.json;
	});
	jack.get( 'path/to/json/file' );

### .delete( url ): Delete a JSON file
	jack.delete( 'path/to/json/file' );


## Status messages
You may have noticed that JackSON.js will display status messages at the top of the browser window.

To turn off status messages...

	var jack = new JackSON({ msg: false })
