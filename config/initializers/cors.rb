Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    # Allow API requests from this location
    origins "http://localhost:3000"
    resource "*", headers: :any, methods: [:get, :post, :put, :patch, :delete, :options, :head],
    # This allows you to pass the above headers back and forth
    credentials: true
  end

  allow do
    # Add the domain that the production app will be on
    origins "https://trh-authentication-app-react.herokuapp.com"
    resource "*", headers: :any, methods: [:get, :post, :put, :patch, :delete, :options, :head],
    # This allows you to pass the above headers back and forth
    credentials: true
  end
end