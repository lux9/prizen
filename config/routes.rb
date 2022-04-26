Rails.application.routes.draw do
  devise_for :users
  root to: 'products#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  get "/refresh_puppis", to: "products#refresh_puppis"
  get "/refresh", to: "products#refresh"
  resources :products
end
