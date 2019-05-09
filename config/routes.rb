# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # Root
  root "homepages#index"
  get "/homepages", to: "homepages#index", as: "homepage"

  # Categories
  resources :categories do
    resources :products, only: [:index]
  end

  resources :categories, only: [:new, :create]

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

  # Order Items
  resources :order_items

  # Cart-Related (Grace wrote these feel free to adjust as needed)
  resource :cart, only: [:show]
  # put "order_items/:id/status", to: "order_items#set_status", as: "order_item_set_status"
  # resources :order_items, only: [:update]

  # patch "/cart/place_order", to: "cart#update_to_paid", as: "update_to_paid"
  # get "/cart", to: "cart#access_cart", as: "cart"
  # patch "/cart", to: "cart#update_cart_info", as: "update_cart_info"
  # delete "/cart/:id/remove_single_item", to: "cart#remove_single_item", as: "remove_single_item"
  # delete "/cart/delete", to: "cart#destroy", as: "cart_destroy"
  # post "/products/:id/add_to_cart", to: "cart#add_to_cart", as: "add_to_cart"

  # Products
  resources :products do
    resources :reviews, only: %i[new create]
  end

  put "products/:id/status", to: "products#set_status", as: "product_set_status"

  get "products/category/:id", to: "products#category", as: "products_category"
end
