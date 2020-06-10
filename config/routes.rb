Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html



  resources :merchants, only: [:index, :show]

  get "/auth/github", as: "github_login"
  get "/auth/:provider/callback", to: "merchants#create", as: "auth_callback"
  post "/logout", to: "merchants#logout", as: "logout"
end
