stormpath-ruby-samples
======================

Stormpath sample code in the Ruby programming language

To run this sample, you will need the Stormpath Ruby SDK gem installed on your system.  You can install it via the following command:

    gem install stormpath-sdk

Then, in the cloned project:

    cd bin/
    ruby stormpath.rb file ~/.stormpath/your_stormpath_api_key.yml -o tenant

This will print out your Tenant data (e.g. name, link to applications and directories).