# JackSON
JackSON is a lightweight server and Javascript API that will create, retrieve, update, and delete JSON files RESTfully.

JackSON will also convert JSON-LD files to Fuseki served RDF automatically.
See [JackRDF](http://github.com/caesarfeta/jackrdf).

It was designed for rapidly prototyping Javascript applications.

### Install
Install ruby and gem.

Run the installer.

	rake server:install

Update the JackSON.config.yml file.

	path: '/where/you/will/store/the/json/files'

Start the server.

	rake server:start

Include JQuery and JackSON.js in your application's HTML.

	<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.9.0/jquery.min.js"></script>
	<script src="http://your.jackson-server.com/JackSON.js"></script>

### Using the JackSON.js API
If you're reading this on GitHub see [API.md](API.md)

If you're reading this on your JackSON instance [click here](/api)

### JackSON and AngularJS
JackSON uses 4 different HTTP methods GET, POST, PUT, DELETE to interact with a JSON file at a URL like this one http://127.0.0.1:4567/data/folder/json.

Armed with this knowledge you should be able to to use AngularJS's $http service to interact with JackSON.

See [examples/angular/index.html](public/examples/angular/index.html)