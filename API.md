# How to JackSON.js

Open your Javascript console and play along!

## Create a JackSON API object
	var jack = new JackSON();

By default the JackSON.js will communicate with the JackSON server accessible at [http://localhost:4567](http://localhost:4567)

If your JackSON server is elsewhere remember to pass its address in a config object when creating the JackSON.js API object...

	var jack = new JackSON({ url: "http://my.doma.in/jackson" })

## Methods
JackSON.js is built on top of JQuery and uses it's AJAX system, which means JackSON.js method calls are asynchronous, so you have to listen for success and error events through the DOM...

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

JSON files retrieved by .get() can all be accessed like so...

	var json = jack.json['path/to/json/file'];

Remember the API calls are asynchronous, so all together you'd need...

	$( document ).on( jack.events.success, function( e ) {
		var json = jack.json['path/to/json/file'];
	});
	jack.get( 'path/to/json/file' );

### .delete( url ): Delete a JSON file
	jack.delete( 'path/to/json/file' );


## Status messages
By default JackSON.js will display status messages at the top of the browser window.

To turn off status messages...

	var jack = new JackSON({ msg: false })

## JSON-LD
JSON-LD is 'linked-data' JSON.
Essentially it is RDF written with JSON.
It looks like this.

	{
	  "@context": {
	    "name": "http://xmlns.com/foaf/0.1/name",
	    "homepage": "http://xmlns.com/foaf/0.1/homepage",
	    "avatar": "http://xmlns.com/foaf/0.1/avatar"
	  },
	  "name": "Manuel Surly",
	  "homepage": "http://manuel.surly.org/",
	  "avatar": "http://twitter.com/account/profile_image/manuelsurly"
	}

JSON uploaded to a JackSON server will be checked for an @context key.
If @context exists it will be converted to RDF.
The JackSON server will then update a SPARQL endpoint with the newly created RDF.  
The location of the SPARQL endpoint is set with **sparql** in **JackSON.config.yml**.  See [JackRDF](http://github.com/caesarfeta/jackrdf).

Note: A single SPARQL endpoint can be updated by several JackSON servers, which means lots of applications can all be gathering data and indexing them in one place.