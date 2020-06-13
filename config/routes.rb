Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :products
  patch 'products/:id/toggle_active', to: 'products#toggle_active', as: 'toggle_active'
  post '/products/:id/add-to-cart', to: 'orders#create', as: 'add_to_cart'

  resources :reviews, only: [:create]

  root 'homepage#index'
  
  resources :categories

  resources :orders, only: [:show, :destroy, :edit, :update, :create]
  get "/cart", to: "orders#show", as: "cart"


  
  resources :merchants, only: [:index, :show]

  get "/auth/github", as: "github_login"
  get "/auth/:provider/callback", to: "merchants#create", as: "auth_callback"
  post "/logout", to: "merchants#logout", as: "logout"
end
