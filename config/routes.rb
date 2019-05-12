# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # Root
  root "products#root"

  # Categories
  resources :categories do
    resources :products, only: [:index]
  end

  resources :categories, only: %i[new create]

  # Merchants
  resources :merchants, except: %i[destroy edit update] do
    resources :orders, only: %i[index show]
  end
  get "merchants/:id/products", to: "merchants#merchants", as: "merchants_products"

  get "merchant-orders-list", to: "orders#merchant_orders_list", as: "merchant_orders_list"

  # Login-related
  get "/merchant/current", to: "merchants#current", as: "current_merchant"
  get "/auth/github", as: "login"
  get "/auth/:provider/callback", to: "merchants#create", as: "callback"
  delete "/logout", to: "merchants#destroy", as: "logout"

  # Orders
  resources :orders do
    get "order-items-for-order", to: "orders#order_items_order", as: "items_order"
  end
  get "checkout", to: "orders#checkout", as: "checkout"
  get "/orders/:order_id/confirmation", to: "orders#confirmation", as: "confirmation"

  # Order Items
  resources :order_items

  # Cart
  resource :cart, only: [:show] do
    get "checkout", to: "carts#checkout", as: "checkout"
  end

  # Products
  resources :products do
    resources :reviews, only: [:new, :create]
  end

  post "products/status", to: "products#set_status", as: "product_set_status"

  get "products/category/:id", to: "products#category", as: "products_category"
end
