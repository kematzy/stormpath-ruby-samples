stormpath-ruby-samples
======================

Stormpath sample code in the Ruby programming language

You need the Stormpath SDK Ruby gem installed on your system, so you may installed by running the following command:

    gem install stormpath-sdk

After cloning this project, test getting your Tenant data:

    ruby stormpath.rb file ~/.stormpath/your_api_key.yml -o tenant

Additionally, to quickly test your Stormpath options, run the bin/stormpath.rb file with no arguments (ruby bin/stormpath.rb) for a guide on how the script works.