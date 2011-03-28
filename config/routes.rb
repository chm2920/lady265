Lady256::Application.routes.draw do
  
  
  match "admin" => "account#login"
  get "account/main"
  get "account/desktop"
  match "logout" => "account#logout"
  
  namespace :admin do    
    get "dashboard"
    resources :deals
    post "deals/index"
    resources :users
    post "users/index"
    resources :run_logs
    post "run_logs/index"
    resources :orders
    post "orders/index"
    resources :carts
    post "carts/index"
  end

  get 'kindeditor/images_list'

  post 'kindeditor/upload'

  root :to => "start#index"
  
  match "*path" => "application#render_not_found"
  
end
