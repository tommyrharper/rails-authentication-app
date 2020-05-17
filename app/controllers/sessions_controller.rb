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