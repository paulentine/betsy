Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root "homepages#index"

  resources :products
  resources :products do
    resources :reviews, only: [:create]
  end

  post "/logout", to: "merchants#logout", as: "logout"
  get "/login", to: "merchants#login_form", as: "login"
  post "/login", to: "merchants#login"
  get "/merchants/current", to: "merchants#current", as: "current_user"

  resources :merchants
  resources :orders
end
