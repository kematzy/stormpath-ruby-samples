# Ruby Web App Example (Rails)

This is a basic web application that will show you how to create, load, edit,
and delete accounts. We've used Rails as the platform for building this sample
application - so you should have plenty of working examples to get you started
on your own Stormpath integration.

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

    1.  Create an application and a directory to store your accounts'
        accounts. Make sure the directory is assigned as a login source
        to the application.

    1.  Take note of the _REST URL_ of the application and of directory
        you just created.

1.  Run the Rake tasks for creating and migrating your database:

    ```
    rake db:create
    rake db:migrate
    ```

1.  Set ENV variables as follows (perhaps in ~/.bashrc):

    ```
    export STORMPATH_API_KEY_FILE_LOCATION=xxx
    export STORMPATH_APPLICATION_URL=aaa
    export STORMPATH_DIRECTORY_URL=bbb
    ```

    There are other ways to pass API information to the Rails client; see the
    [Stormpath Rails Gem documentation][stormpath-rails-gem] for more info.

1.  Run the Rails server:

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

1.  Visit the now-running site in your browser at http://0.0.0.0:3000

## Common Use Cases

### User Creation

This tutorial assumes you've not yet created any accounts in the Stormpath
directory mentioned in the Quickstart Guide.

To create your first account:

1.  Fire up the demo application, as explained in the Quickstart Guide

1.  Open http://0.0.0.0:3000 in your web browser

1.  Click the "Don't have an account?" link

1.  Complete the form and click the "Save" button

Congratulations! Your first account has been created. Assuming all has gone well,
you should be able to log in to the sample application using its email and
password.

Interesting to note is that **your User model (what's actually being created
here) has had the Stormpath::Rails::Account module included**, which hooks various
lifecycle events (initialization, creation, updating, destruction) to pull in
data from the Stormpath API. You are free to augment this User model as you see
fit (the example application adds a "css_background" property); **the properties
you add will be persisted to the local database, while the proxied Stormpath
properties will not.**

### Listing Users

After creating an account ("User Creation") and logging in, you will be
presented with a list of all the User entities (extending the functionality of
Stormpath::Rails::Account) created to-date. These User entities have been
loaded via the User (ActiveRecord) class like so (example from
"app/controllers/users_controller.rb"):

```ruby

def index
  @users = User.all
end

```

What's happening here is that we're instantiating a single User instance per
record in our users table, which in turn triggers the "after_initialize"
lifecycle event so as to load the Stormpath Account data, by URL. **It is
important to note that no Stormpath data is persisted to your database
beyond the Resource URL, which uniquely identifies the Resource in the
Stormpath system.** By the time the consumer of the result of the "Users.all"
call has its data, the User models have all been hydrated with data from the
Stormpath API.

### Interacting with the Stormpath Rails Client

The Stormpath Rails client can be interacted with (after requiring the
"stormpath-rails" gem) and then invoking methods on the class itself:

```ruby
# first...
require 'stormpath-rails'

# later...
Stormpath::Rails::Client.send_password_reset_email("foo@example.com")
Stormpath::Rails::Client.create_account({ ... })

```

A complete list of functionality exposed by this client can be found in the
[Stormpath Rails Gem documentation][stormpath-rails-gem]. Essentially, this
client allows the consumer to perform the basic CRUD operations required by a
system using the Stormpath service: creating a account, deleting an account,
authenticating a password reset token, and so forth.

## Testing Specific Configurations

### Post-Create Account Validation

It is possible to configure a Stormpath directory in such a way that when accounts
are provisioned to it that they must be verified (by clicking a link) via email
before logging in. The verification link in the email will by default point to
the Stormpath server - but can be configured to point to your local server. This
is useful if you wish to prevent the account from having to go to the Stormpath
site after registration.

To enable post-creation verififation for a directory:

1.  Head to the [Stormpath Admin UI][stormpath-admin-login], log in, and click
    "Directories."

1.  From there, click the directory whose REST URL you have used to configure
    your application (see Quickstart Guide):

1.  Click "Workflows" and then "Show" link next to "Account Registration and
    Verification".

1.  Click the box next to "Enable Registration and Verification
    Workflow."

1.  Finally, click the box next to "Require newly registered accounts to verify
    their email address."

Now account-creation will prompt an email to be sent to the email address attached
to that account. You will not be able to log in with that account until they've
clicked the verification link in the email-body.

If you wish for that email link to point to your local server - which will then
use the Stormpath SDK to verify the account - modify "Account Verification Base
URL" to "http://0.0.0.0:3000/accounts/verify".

### Local Password Reset Token Validation

It is possible to configure a Stormpath directory in such a way that when accounts
reset their password that the email they receive points to a token-verification
URL on your local server. If you wish to configure the directory to point to
your local server (instead of the Stormpath server):

1.  Head to the [Stormpath Admin UI][stormpath-admin-login], log in, and click
    "Directories."

1.  From there, click the directory whose REST URL you have used to configure
    your application (see Quickstart Guide):

1.  Click "Workflows" and then "Show" link next to "Password Reset"

1.  Change the value of "Base URL" to
    "http://0.0.0.0:3000/password_reset_tokens"

Now the email a account receives after resetting their password will contain a link
pointing to a password reset token-verification URL on your system.

### Group Membership

In order to demonstrate the Stormpath Group functionality, the demo application
conditionally shows / hides a "delete" link next to each account on the
accounts-listing page based on the logged-in account's membership in a group named
"admin".

If you wish to experiment with group membership:

1.  Head to the [Stormpath Admin UI][stormpath-admin-login], log in, and click
    "Directories."

1.  From there, click the directory whose REST URL you have used to configure
    your application (see Quickstart Guide):

1.  Click "Groups" and then "Create Group"

1.  Name the group "admin"

1.  From the group-list screen, click the name of the "admin" group

1.  Click the "Accounts" tab and then "Assign Accounts"

1.  Select an account and then click "Assign Account"

This account has associated with the "admin" group. Upon logging in to the
sample application with this account, you will see a new "delete" link appear
next to each row in the list of accounts.

  [rubygems-installation-docs]: http://docs.rubygems.org/read/chapter/3
  [stormpath]: http://stormpath.com/
  [stormpath-admin-login]: http://api.stormpath.com/login
  [create-api-keys]: http://www.stormpath.com/docs/ruby/product-guide#AssignAPIkeys
  [stormpath-rails-gem]: https://github.com/stormpath/stormpath-rails
