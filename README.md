# Rails authentication app

## Notes

## How to create this application from scratch

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
