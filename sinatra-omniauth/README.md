# Ruby Web App Example (Sinatra)

This is a basic web application that will show you how to use the Stormpath
OmniAuth Strategy in a Sinatra context.

## Installation

These installation steps assume you've already installed RubyGems. If you've
not yet installed RubyGems, go [here][rubygems-installation-docs].

You'll need the Bundler gem in order to install dependencies listed in your
project's Gemfile. To install Bundler:

```
$ gem install bundler
```

Then, install dependencies using Bundler:

```
$ bundle install
```

## Quickstart Guide

1.  If you have not already done so, register as a developer on
    [Stormpath][stormpath] and set up your API credentials and resources:

    1.  Create a [Stormpath][stormpath] developer account and [create your API Keys][create-api-keys]
        downloading the <code>apiKey.properties</code> file into a <code>.stormpath</code>
        folder under your local home directory.

    2.  Create an application and a directory to store your accounts'
        accounts. Make sure the directory is assigned as a login source
        to the application.

    3.  Take note of the _REST URL_ of the application and of directory
        you just created.

2.  Set ENV variables as follows (perhaps in ~/.bashrc):

    ```
    export STORMPATH_RUBY_SAMPLE_APPLICATION_URL=REST_URL_OF_APPLICATION_HERE
    export STORMPATH_RUBY_SAMPLE_API_KEY_FILE_LOCATION=PATH_TO_AFOREMENTIONED_APIKEY_PROPERTIES_FILE
    ```

    There are other ways to pass API information to the SDK client; see the
    [Stormpath SDK documentation][stormpath-sdk] for more info.

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

4.  Visit the now-running site in your browser at http://0.0.0.0:9292

  [rubygems-installation-docs]: http://docs.rubygems.org/read/chapter/3
  [stormpath]: http://stormpath.com/
  [create-api-keys]: http://www.stormpath.com/docs/ruby/product-guide#AssignAPIkeys
