# Ruby Web App Example (Roda)

This is a basic web application that will show you how to use the Stormpath OmniAuth Strategy in a Roda context.

## Installation

These installation steps assume you've already installed RubyGems. If you've not yet installed RubyGems, go [here](http://docs.rubygems.org/read/chapter/3).

You'll need the Bundler gem in order to install dependencies listed in your project's Gemfile. To install Bundler:

    $ gem install bundler

Then, install dependencies using Bundler:

    $ bundle install


## Quickstart Guide

1.  If you have not already done so, register as a developer on [Stormpath](http://stormpath.com/) and set up your API credentials and resources:

    1.  Create a [Stormpath](http://stormpath.com/) developer account and [create your API Keys](https://stormpath.com/docs/console/product-guide#!ManageAPIkeys) downloading the <code>apiKey.properties</code> file into a <code>.stormpath</code> folder under your local home directory.

    2.  Through the [Stormpath Admin UI](https://stormpath.com/docs/console/product-guide#!Administration), create yourself an [Application Resource](https://stormpath.com/docs/rest/product-guide#!Applications). Ensure that this is a new application and not the default administrator one that is created when you create your Stormpath account. 

        On the Create New Application screen, make sure the "Create a new directory  with this application" box is checked. This will provision a [Directory Resource](https://stormpath.com/docs/rest/product-guide#!Directories) along with your new Application Resource and link the Directory to the Application as an [Account Store](https://stormpath.com/docs/rest/product-guide#!ManageAccountStores). This will allow users associated with that Directory Resource to authenticate and have access to that Application Resource. 

        It is important to note that although your developer account (step 1) comes with a built-in Application Resource (called "Stormpath") - you will still need to provision a separate Application Resource.

    3.  Take note of the _REST URL_ of the Application you just created. Your web application will communicate with the Stormpath API in the context of this one Application Resource (operations such as: user-creation, authentication, etc.)

2.  Set ENV variables as follows (perhaps in ~/.bashrc):

    ```
    export STORMPATH_API_KEY_FILE_LOCATION="/Users/john/.stormpath/apiKey.properties"
    export STORMPATH_APPLICATION_URL="https://api.stormpath.com/v1/applications/YOUR_APP_ID"
    ```

    There are other ways to pass API information to the SDK client; see the
    [Stormpath SDK documentation](https://stormpath.com/docs/ruby/product-guide) for more info.

3.  Run the application with Rack (installed by Bundler):

    ```
    $ rackup config.ru
    ```

    You should see output resembling the following:

    ```
    [2013-05-03 11:38:19] INFO  WEBrick 1.3.1
    [2013-05-03 11:38:19] INFO  ruby 2.0.0 (2013-02-24) [x86_64-darwin12.2.1]
    [2013-05-03 11:38:19] INFO  WEBrick::HTTPServer#start: pid=9304 port=9292
    ```

4.  Visit the now-running site in your browser at http://0.0.0.0:9292. You can now authenticate using any of the accounts that are associated with the Stormpath application resource you have configured the sample application to connect to.
