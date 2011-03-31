Lady256::Application.routes.draw do
  
  resources :categories
  
  match "c/:id" => "start#category"
  match "(:c)/(:id).html" => "start#topic"
  
  match "admin" => "account#login"
  get "account/main"
  get "account/desktop"
  match "logout" => "account#logout"
  
  namespace :admin do
    get "categories/index"
    post "categories/index"
    resources :categories
    get "topics/index"
    post "topics/index"
    resources :topics
    get "posts/index"
    post "posts/index"
    get "posts/all"
    post "posts/all"
    get "posts/import"
    post "posts/import"
    resources :posts
    get "run_logs/index"
    post "run_logs/index"
    resources :run_logs
  end

  get 'kindeditor/images_list'

  post 'kindeditor/upload'

  root :to => "start#index"
  
  match "*path" => "application#render_not_found"
  
end
