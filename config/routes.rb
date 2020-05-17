Rails.application.routes.draw do
  resoures :sessions, only: [:create]
  root to: "static#home"
end
