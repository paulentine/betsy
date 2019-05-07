Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root "homepages#index"
  resources :products do
    resources :reviews, only: [:new, :create]
  end
  resources :orders do
    get "confirmation", to: "orders#confirmation", as: "confirmation"
  end

  resources :orders do
    get "order_items_order", to: "orders#order_items_order", as: "items_order"
  end

  resources :merchants, except: [:destroy, :edit, :update] do
    resources :orders, only: [:index, :show]
  end

  get "merchant-orders-list", to: "orders#merchant_orders_list", as: "merchant_orders_list"


  get "/merchant/current", to: "merchants#current", as: "current_merchant"

  get "/auth/github", as: "login"
  get "/auth/:provider/callback", to: "merchants#create", as: "callback"

  delete "/logout", to: "merchants#destroy", as: "logout"

  get "products/category/:id", to: "products#category", as: "category"
  resources :categories, :except => [:destroy]
end
