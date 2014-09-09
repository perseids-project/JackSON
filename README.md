# JackSON
JackSON is a lightweight server and Javascript api that will create, update, and retrieve json files RESTfully.
It is especially useful for prototyping Javascript web-applications.
When used responsibly, client application data structures can be implemented, tested, and revised rapidly.

### Warning
This is a very new project.  
Don't expect it to be secure.

### Install
Install ruby and gem.

Run the install script to install the necessary gems.

	./install.sh

Update the JackSON.config.yml file.

	path: '/where/you/will/store/the/json/files'

Start the server.

	./start.sh

Include JQuery and JackSON.js into your application's HTML.

	<script src="//ajax.googleapis.com/ajax/libs/jquery/1.9.0/jquery.min.js"></script>
	<script src="//your.jackson-server.com/JackSON.js"></script>

### Use
If you're reading this on GitHub see CLIENT.md.

If you're reading this on your JackSON instance [click here](/dev).