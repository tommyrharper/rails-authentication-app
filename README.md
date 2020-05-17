# Rails authentication app


# How to create this application from scratch

## App creation and Initial configuration

### Step 1

Start by running the following command to create a rails application:
```
rails new authentication_app --database=postgresql
rails db:create
```
Add two gems to the Gemfile:
1. bcrypt
2. rack-cors
Run ```bundle``` to install those gems.

### Step 2

Create the following files:
```
config/initializers/cors.rb
config/initializers/sessions_sto
```

```config/initializers/cors.rb``` is used to whitelist certain domains because we are going to be passing secure cookies back and forth from the front end application and the backend application.

Therefore you have to use a tool called credentials and we use cors.rb to set some rules as to how you are going to be able to communicate.

```config/initializers/session_store.rb``` is where we define what the secure cookies are going to be structured like.

### Step 3

Navigate to ```config/routes.rb``` and add in the base root route so we can see if it is working:
```ruby
Rails.application.routes.draw do
  root to: "static#home"
end
```
Then create a controller for it ```app/controllers/static_controller.rb```.
Then add in the following code:
```ruby
class StaticController < ApplicationController
  def home
    render json: { status: "It's working" }
  end
end
```
Now we have added all the key elements we need to implement authentication.
By running ```rails s``` we should find ```{ "status": "It's working" }``` on localhost:3000

## Building User Model and Session controller for the API

### Step 1
Run 
```
rails g model User email password_digest
rails db:migrate
```
Then add to ```app/models/user.rb
```ruby
class User < ApplicationRecord
  has_secure_password

  validates_presence_of :email
  validate_uniqueness_of :email
end
```

### Step 2

Run ```rails c``` to enter the rails console.
```
> User.create!(email: "z@dev.com", password: "asdfasdf", password_confirmation: "asdfasdf")
```
This will check that it works so far.

Notice that it automatically requires a password_confirmation field and it returns a password digest.

Head to ```config/routes.rb``` and add the following route:
```ruby
resoures :sessions, only: [:create]
```

Then create ```app/controllers/sessions_controller.rb``` and add in the following code:

```ruby
class SessionsController < ApplicationController
  def create
    user = User
      .find_by(email: params["user"]["email"])
      .try(:authenticate, params["user"]["password"])

      if user
        # If the user is created we make a cookie
        session[:user_id] = user.id
        reder json: {
          status: :created,
          logged_in: ture,
          user: user
        }
      else
        render json: { status: 401 }
      end
  end
end
```
Notice the authenticate method is built in to rails.

# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
