# JackSON
JackSON is a lightweight server and Javascript api that will create, update, and retrieve json files RESTfully.
It is especially useful for prototyping Javascript web-applications.
When used responsibly, client application data structures can be implemented, tested, and revised rapidly.

# Warning
This is a very new project.  Don't expect it to be secure.

# Install
	./install.sh

# How to use
* Update the config file.
	
		path: '/where/you/will/store/the/json/files'

* Start the server.

		./start.sh

* Include JQuery and JackSON.js into your prototype application

		<script src="//ajax.googleapis.com/ajax/libs/jquery/1.9.0/jquery.min.js"></script>
		<script src="//your.jackson-server.com/JackSON.js"></script>
