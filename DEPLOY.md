# Deploying in Apache with Phusion Passenger

	gem install passenger
	passenger-install-apache2-module

This server could be running on a system with other servers using a different version of ruby, so you might be using 

If you're using **rbenv** instead of **rvm** you might get an error message like this one...

	passenger-install-apache2-module: command not found

Here's what you do to fix it...

	rbenv version
		2.1.2 (set by /Users/username/.rbenv/version)
	cd /Users/username/.rbenv/versions/2.1.2/bin/
	./passenger-install-apache2-module

If **passenger-install-apache2-module** opens follow the prompts.

At the end of the install, you'll be given a **passenger_module** configuration snippet.

	LoadModule passenger_module /Users/username/.rbenv/versions/2.1.2/lib/ruby/gems/2.1.0/gems/passenger-4.0.50/buildout/apache2/mod_passenger.so
	<IfModule mod_passenger.c>
	  PassengerRoot /Users/username/.rbenv/versions/2.1.2/lib/ruby/gems/2.1.0/gems/passenger-4.0.50
	  PassengerDefaultRuby /Users/username/.rbenv/versions/2.1.2/bin/ruby
	</IfModule>

Add it to your Apache configuration file, most likely in **/etc/apache2/httpd.conf**.

Create a Virtual Host configuration.  If you're using a non-standard port number make sure you add a Listen config.

[Here's the rest of the instructions.](http://recipes.sinatrarb.com/p/deployment/apache_with_passenger?#article)