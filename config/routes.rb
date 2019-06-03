Rails.application.routes.draw do
  
  root 'static_pages#home'
  get "/about", to: 'static_pages#about'
  get "/contact", to: 'static_pages#contact'
  get "/login", to: "sessions#new" 
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"
 
  resources :users
  resources :posts, only: [:edit, :update, :create, :destroy]
  resources :account_activations, only: [:edit]

end
