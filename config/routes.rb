Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root "homepages#index"

  resources :orders
  resources :products do
    resources :reviews, only: [:create]
  end
  resources :merchants, except: [:destroy, :edit, :update] do
    resources :orders, only: [:index, :show]
  end

  get "/orders/confirmation", to: "orders#confirmation", as: "order_confirmation"

  get "/merchant/current", to: "merchants#current", as: "current_merchant"

  get "/auth/github", as: "login"
  get "/auth/:provider/callback", to: "merchants#create", as: "callback"
  delete "/logout", to: "merchants#destroy", as: "logout"

  get "products/category/:id", to: "products#category", as: "category"
  resources :categories, :except => [:destroy]
end
