Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :products
  resources :order
  resources :merchants do
    resources :orders, [:index, :show]
  end

  get "/orders/confirmation", to:"orders#confirmation", as:"order_confirmation"

end
