Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :products
  resources :order  
  resources :merchants, except: [:destroy, :edit, :update] do
    resources :orders, [:index, :show]
  end

  get "/orders/confirmation", to:"orders#confirmation", as:"order_confirmation"
  
  get "/auth/github", as: "github_login"
  get "/auth/:provider/callback", to: "merchants#create"
  delete "/logout", to: "merchants#destroy", as: "logout"
 
end
