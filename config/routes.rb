Rails.application.routes.draw do


  root 'users#home'

  get "/gamechat", to: 'users#gamechat'
  post "/checkup", to: 'users#checkup'
  get "/navbar", to: 'users#navbar_entries'
  get "/about", to: 'static_pages#about'
  get "/contact", to: 'static_pages#contact'
  get "/mini_chat", to: 'messages#mini_chat'
  get "/login", to: "sessions#new" 
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"
 
  resources :users
  resources :posts, only: [:edit, :update, :create, :destroy]
  resources :account_activations, only: [:edit]
  resources :password_reset, only:[:new, :create, :edit,:update]
  resources :relationships, only:[:create, :update, :destroy]
  resources :messages, only:[:create, :destroy]
  resources :chessgames, only:[:create, :update, :destroy]

  
  # Server websocket cable requests in-process
   mount ActionCable.server, at: '/cable'

end
