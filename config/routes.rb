Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root "homepages#index"
  resources :products do
    resources :reviews, only: [:new, :create]
  end

  
  resources :orders

  resources :merchants, except: [:destroy, :edit, :update] do
    resources :orders, only: [:index, :show]
  end

  get "/orders/order-items-for-order", to: "orders#order_items_order", as: "order_items_order"
  get "/orders/confirmation", to: "orders#confirmation", as: "order_confirmation"

  get "/merchant/current", to: "merchants#current", as: "current_merchant"

  get "/auth/github", as: "login"
  get "/auth/:provider/callback", to: "merchants#create", as: "callback"

  delete "/logout", to: "merchants#destroy", as: "logout"

  get "products/category/:id", to: "products#category", as: "category"
  resources :categories, :except => [:destroy]
end
