# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # Root
  root "homepages#index"

  # Categories
  resources :categories, except: [:destroy]

  # Merchants
  resources :merchants, except: [:destroy, :edit, :update] do
    resources :orders, only: [:index, :show]
  end

  get "merchant-orders-list", to: "orders#merchant_orders_list", as: "merchant_orders_list"

  # Login-related
  get "/merchant/current", to: "merchants#current", as: "current_merchant"
  get "/auth/github", as: "login"
  get "/auth/:provider/callback", to: "merchants#create", as: "callback"
  delete "/logout", to: "merchants#destroy", as: "logout"

  # Orders
  resources :orders do
    get "confirmation", to: "orders#confirmation", as: "confirmation"
    get "order-items-for-order", to: "orders#order_items_order", as: "items_order"
  end

  # Products
  resources :products do
    resources :reviews, only: %i[new create]
  end

  get "products/category/:id", to: "products#category", as: "products_category"
end
