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

<<<<<<< HEAD
  get "/auth/github", as: "github_login"
  get "/auth/:provider/callback", to: "merchants#create", as: "auth_callback"
=======
  get "/auth/github", as: "login"
  get "/auth/:provider/callback", to: "merchants#create", as: "callback"
>>>>>>> 68e07acf4843ce31a6d2fe154b738f79ca6e2b8e
  delete "/logout", to: "merchants#destroy", as: "logout"

  get "products/category/:id", to: "products#category", as: "category"
  resources :categories, :except => [:destroy]
end
