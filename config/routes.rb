Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :products
  patch 'products/:id/toggle_active', to: 'products#toggle_active', as: 'toggle_active'
  post '/products/:id/add-to-cart', to: 'orders#add_to_cart', as: 'add_to_cart'
  
  resources :reviews, only: [:create]

  root 'homepage#index'
  
  resources :categories

  resources :orders, only: [:create, :destroy, :edit, :update] do
    resources :order_items, only: [:update, :destroy]
  end    

  resources :order_items, only: [:create]
  get "/cart", to: "orders#cart", as: "cart"

  post '/cart/:order_item_id/set-quantity', to: "orders#set_quantity", as: "set_quantity"

  
  resources :merchants, only: [:index, :show]
  get "/dashboard", to: 'merchants#dashboard', as: 'dashboard'

  get "/auth/github", as: "github_login"
  get "/auth/:provider/callback", to: "merchants#create", as: "auth_callback"
  post "/logout", to: "merchants#logout", as: "logout"
end
