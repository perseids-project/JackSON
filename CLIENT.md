# JackSON.client.js

## Get a a JackSON api object
	var jack = new JackSON();

## Create a new json file
	jack.post( 'path/to/json/file', { "foo": "bar" } );

You can always add .json to the url of any JackSON method.

	jack.post( 'path/to/json/file.json', { "foo": "bar" } );

This maps the the same json file as the line above.
Only use the post method when creating a new json file.

## Update a json file
	jack.put( 'path/to/json/file', { "foo": "buzz" } );

## Retrieve a json file
	jack.get( 'path/to/json/file' );

