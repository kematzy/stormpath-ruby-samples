Ruby CLI example
================

This is a little quickstart command line program that will show you how to
create a Stormpath SDK client using a Stormpath API Key file and communicate
with the Stormpath REST API.

To run this sample, you will need the Stormpath Ruby SDK gem installed on your
system.  You can install it via the following command:

    bundle install

Then, in the cloned project:

    cd bin/
    bundle exec ./stormpath.rb file ~/.stormpath/apiKey.properties -o tenant

This will print out your Tenant data (e.g. name, link to applications and
directories).  If you see your Tenant's @properties printed, you've successfully
communicated with Stormpath via the Ruby SDK!
