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
resources :sessions, only: [:create]
```

### Step 3

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
        render json: {
          status: :created,
          logged_in: true,
          user: user
        }
      else
        render json: { status: 401 }
      end
  end
end
```
Notice the authenticate method is built in to rails.

## Implementing Registration controller and Final Authentication Features

### Step 1
Add to ```routes.rb``` the following route:
```ruby
resources :registration, only: [:create]
```
Then create ```app/controllers/registrations_controller.rb``` and enter in the following code:
```ruby
class RegistrationsController < ApplicationController
  def create
    user = User.create!(
      email: params['user']['email'],
      password: params['user']['password'],
      password_confirmation: params['user']['password_confirmation']
    )

    if user
      session[:user_id] = user.id 
      render json: {
        status: :created,
        user: user
      }
    else
      render json: { status: 500 }
    end
  end
end
```

### Step 2
Add into ```application_controller```
```ruby
skip_before_action :verify_authenticity_token
```
Then test it is running with the following by running ```rails s``` and then in a new terminal:
```
curl --header "Content-Type: application/json" --request POST --data '{"user": {"email": "z@dev.com", "password": "asdfasdf"}}' http://localhost:3000/sessions
```

### Step 3

Update ```routes.rb``` again with these new routes:
```ruby
delete :logout, to: "sessions#logout"
get :logged_in, to: "sessions#logged_in"
```
Then add a new method to ```sessions_controller.rb```:
```ruby
def logged_in
end
```

### Step 4

Then create ```app/controllers/concerns/current_user_concern.rb```
And give it the following code:
```ruby
module CurrentUserConcern
  extend ActiveSupport::CurrentUserConcern

  included do
    before_action :set_current_user
  end

  def set_current_user
    if sessions[:user_id]
      @current_user = User.find(session[:user_id])
    end
  end
end
```

### Step 5

Now we need to include this module in ```sessions_conttroller.rb``` as follows:
```ruby
class SessionsController < ApplicationController
  include CurrentUserConcern
  def create
  ....
```
And update the logged_in method:
```ruby
  def logged_in
    if @current_user
      render json: {
        logged_in: true,
        user: @current_user
      }
    else 
      render json: {
        logged_in: false
      }
    end
  end
```

### Step 6

Now add a logout method to ```sessions_controller.rb```
```ruby
def logout
  reset_session
  render json: { status : 200, logged_out: true }
end
```

## Configuring the API Session Store to Work in All environments

### Step 1



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
