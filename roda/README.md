# Ruby Web App Example (Roda)

This is a basic web application that will show you how to create, load, edit, and delete accounts using the Stormpath Ruby SDK and [Roda](http://roda.jeremyevans.net). 

## Installation

These installation steps assume you've already installed RubyGems. If you've not yet installed RubyGems, go [here](http://docs.rubygems.org/read/chapter/3).

You'll need the Bundler gem in order to install dependencies listed in your project's Gemfile. To install Bundler:

    $  gem install bundler


Then, install dependencies using Bundler:

    $  bundle install


## Quickstart Guide

1.  If you have not already done so, register as a developer on [Stormpath](http://stormpath.com/) and set up your API credentials and resources:
    
    1.  Create a [Stormpath](http://www.stormpath.com) developer account and [create your API Keys](http://www.stormpath.com/docs/ruby/product-guide#AssignAPIkeys) downloading the <code>apiKey.properties</code> file into a <code>.stormpath</code> folder under your local home directory.
    
    2.  Through the [Stormpath Admin UI](http://api.stormpath.com/login), create yourself an [Application Resource](http://www.stormpath.com/docs/stormpath-basics#keyConcepts). Ensure that this is a new application and not the default administrator one that is created when you create your Stormpath account.
        
        On the Create New Application screen, make sure the "Create a new directory with this application" box is checked. This will provision a [Directory Resource](http://www.stormpath.com/docs/stormpath-basics#keyConcepts) along with your new Application Resource and link the Directory to the Application as an [Account Store](http://www.stormpath.com/docs/stormpath-basics#keyConcepts). This will allow users associated with that Directory Resource to authenticate and have access to that Application Resource.
        
        It is important to note that although your developer account (step 1) comes with a built-in Application Resource (called "Stormpath") - you will still need to provision a separate Application Resource.
        
    3.  Take note of the _REST URL_ of the Application you just created. Your web application will communicate with the Stormpath API in the context of this one Application Resource (operations such as: user-creation, authentication, etc.)
        
2.  Set ENV variables as follows (perhaps in ~/.bashrc):

      ```
      export STORMPATH_API_KEY_FILE_LOCATION=xxx
      export STORMPATH_APPLICATION_URL=aaa
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

4.  Visit the now-running site in your browser at http://0.0.0.0:9292

Note: By design, you will need to first create a user with the application before being able to authenticate that user. Users already existing in your Stormpath database already will not be automatically propagated to the sample app's internal database. 

## Common Use Cases

### User Creation

This tutorial assumes you've not yet created any accounts in the Stormpath directory mentioned in the Quickstart Guide.

To create your first account:

1.  Fire up the demo application, as explained in the Quickstart Guide

2.  Open http://0.0.0.0:9292 in your web browser

3.  Click the "Don't have an account?" link

4.  Complete the form and click the "Save" button

Congratulations! Your first account has been created. Assuming all has gone well, you should be able to log in to the sample application using its email and password.

If you're interested in the log in/out implementation, check out routes/session.rb. In that file you'll find a route whose handler shows the login view (GET "/session/new") and a route whose handler forwards your username and password off to Stormpath for authentication (POST "/session").

### Listing Accounts

After creating an account ("User Creation") and logging in, you will be presented with a list of all the accounts created to-date. These accounts have been obtained from the Stormpath application and stored as settings of your Roda app, like so:

    class SampleApp < Roda
      ...
      opts[:client]       = Stormpath::Client.new({ :api_key_file_location => ENV['STORMPATH_API_KEY_FILE_LOCATION'] })
      opts[:application]  = opts[:client].applications.get(ENV['STORMPATH_APPLICATION_URL'])
      ...
    end


### Accessing the Stormpath Client and Application

When the Roda sample application starts up, a request is made to the Stormpath API in order to load your application. The resulting Stormpath Resource objects are accessible through the "opts" hash on your Roda application, like so:

    # in routes/accounts.rb
    
    SampleApp.route("sample_route") do |r|
    
      r.get do
        ...
        opts[:client]       # an instance of a Stormpath Client
        opts[:application]  # an instance of the Stormpath Application
        ...
      end
    end
    


## Testing Specific Configurations

### Post-Create Account Validation

It is possible to configure a Stormpath directory in such a way that when accounts are provisioned to it that they must be verified (by clicking a link) via email before logging in. The verification link in the email will by default point to the Stormpath server - but can be configured to point to your local server. This is useful if you wish to prevent the account from having to go to the Stormpath site after registration.

To enable post-creation verififation for a directory:

1.  Head to the [Stormpath Admin UI](http://api.stormpath.com/login), log in, and click "Directories."

2.  From there, click the directory whose REST URL you have used to configure your application (see Quickstart Guide):

3.  Click "Workflows" and then "Show" link next to "Account Registration and Verification".

4.  Click the box next to "Enable Registration and Verification Workflow."

5.  Finally, click the box next to "Require newly registered accounts to verify their email address."

After creating an account, an email will be sent to the email address specified during creation. This email contains a verification link which must be clicked before the account can authenticate successfully.

If you wish for that email link to point to your local server - which will then use the Stormpath SDK to verify the account - modify "Account Verification Base URL" to "http://0.0.0.0:9292/account_verifications".

### Local Password Reset Token Validation

It is possible to configure a Stormpath directory in such a way that when accounts reset their password that the email they receive points to a token-verification URL on your local server. If you wish to configure the directory to point to your local server (instead of the Stormpath server):

1.  Head to the [Stormpath Admin UI](http://api.stormpath.com/login), log in, and click "Directories."

2.  From there, click the directory whose REST URL you have used to configure your application (see Quickstart Guide):

3.  Click "Workflows" and then "Show" link next to "Password Reset"

4.  Change the value of "Base URL" to "http://0.0.0.0:9292/password_reset_tokens"

Now the email a account receives after resetting their password will contain a link pointing to a password reset token-verification URL on your system.

### Group Membership

In order to demonstrate the Stormpath Group functionality, the demo application conditionally shows / hides a "delete" link next to each account on the accounts-listing page based on the logged-in account's membership in a group named "admin".

If you wish to experiment with group membership:

1.  Head to the [Stormpath Admin UI](http://api.stormpath.com/login), log in, and click "Directories."

2.  From there, click the directory whose REST URL you have used to configure your application (see Quickstart Guide):

3.  Click "Groups" and then "Create Group"

4.  Name the group "admin"

5.  From the group-list screen, click the name of the "admin" group

6.  Click the "Accounts" tab and then "Assign Accounts"

7.  Select an account and then click "Assign Account"

This account has now been associated with the "admin" group. Upon logging in to the sample application with this account, you will see a new "Delete" button appear next to each row in the list of accounts.
