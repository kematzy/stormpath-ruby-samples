# Stormpath Omniauth Example (Rails)

This is a sample Rails app for demonstrating authentication using the [Stormpath Omniauth gem][stormpath-omniauth-gem].

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

    1.  Create a [Stormpath][stormpath] developer account and
        [create your API Keys][create-api-keys] downloading the
        <code>apiKey.properties</code> file into a <code>.stormpath</code>
        folder under your local home directory.

    2.  Through the [Stormpath Admin UI][stormpath-admin-login], create yourself
        an [Application Resource][concepts]. Ensure that this is a new application and 
        not the default administrator one that is created when you create your Stormpath account.
        
        On the Create New Application screen, make sure the "Create a new directory 
        with this application" box is checked. This will provision a [Directory Resource][concepts] along
        with your new Application Resource and link the Directory to the
        Application as a [Login Source][concepts]. This will allow users
        associated with that Directory Resource to authenticate and have access
        to that Application Resource.

        It is important to note that although your developer account (step 1)
        comes with a built-in Application Resource (called "Stormpath") - you
        will still need to provision a separate Application Resource.

    3.  Take note of the _REST URL_ of the Application you just created. Your
        web application will communicate with the Stormpath API in the context
        of this one Application Resource (operations such as: user-creation,
        authentication, etc.)

2.  Set ENV variables as follows (perhaps in ~/.bashrc):

    ```
    export STORMPATH_API_KEY_FILE_LOCATION=xxx
    export STORMPATH_APPLICATION_URL=aaa
    ```

    There are other ways to pass API information to the Rails client; see the [Stormpath Rails Gem documentation][stormpath-rails-gem] for more info.  

3.  CD into the `rails-omniauth' directory.

4.  Run the Rake tasks for creating and migrating your database:

    ```
    rake db:create
    rake db:migrate
    ```

5.  Run the Rails server:

    ```
    $ rails s
    ```

    You should see output resembling the following:

    ```
    $ rails s
    => Booting WEBrick
    => Rails 3.2.13 application starting in development on http://0.0.0.0:3000
    => Call with -d to detach
    => Ctrl-C to shutdown server
    [2013-05-03 15:01:54] INFO  WEBrick 1.3.1
    [2013-05-03 15:01:54] INFO  ruby 2.0.0 (2013-02-24) [x86_64-darwin12.2.1]
    [2013-05-03 15:01:54] INFO  WEBrick::HTTPServer#start: pid=11614 port=3000
    ```

6.  Visit the now-running site in your browser at <code>http://localhost:3000</code>.

    You should see a sign in form. You can log in and out of Stormpath using the
    credentials for an account associated with <code>STORMPATH_APPLICATION_URL</code>.
    Note that you will need to have created a user in this directory before hand. 

#### Notes

The purpose of this app is to exercise Omniauth authentication only. However, keep in mind that you can do anything provided to you by [stormpath-rails][https://github.com/stormpath/stormpath-rails].

Since the <code>User</code> model in this app mixes in <code>Stormpath::Rails::Account</code>,
the following is possible:

    ```
    User.authenticate 'foo@example.com', 'secret-password'
    User.send_password_reset_email 'foo@example.com'
    ```

A complete list of functionality exposed by this client can be found in the
[Stormpath Rails Gem documentation][stormpath-rails-gem].

  [rubygems-installation-docs]: http://docs.rubygems.org/read/chapter/3
  [stormpath]: http://stormpath.com/
  [stormpath-admin-login]: http://api.stormpath.com/login
  [create-api-keys]: http://www.stormpath.com/docs/ruby/product-guide#AssignAPIkeys
  [stormpath-rails-gem]: https://github.com/stormpath/stormpath-rails
  [stormpath-omniauth-gem]: https://github.com/stormpath/stormpath-omniauth
  [concepts]: http://www.stormpath.com/docs/stormpath-basics#keyConcepts
