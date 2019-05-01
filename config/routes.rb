Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get "/auth/github", as: "github_login"
  get "/auth/:provider/callback", to: "merchants#create"
  delete "/logout", to: "merchants#destroy", as: "logout"
  
  resources :merchants, except: [:destroy, :edit, :update] do
    # resources :orders, [:index, :show]
  end

  resources :order

  get "/orders/confirmation", to:"orders#confirmation", as:"order_confirmation"
end
