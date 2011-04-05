Lady256::Application.routes.draw do
  
  resources :categories
  
  match "c/:id" => "start#category"
  match "(:c)/(:date)_(:id)_(:page).html" => "start#topic"
  match "(:c)/(:date)_(:id).html" => "start#topic"
  
  match "admin" => "account#login"
  get "account/main"
  get "account/desktop"
  match "logout" => "account#logout"
  
  get "tao/lady"
  get "tao/beauty"
  get "tao/jewelry"
  get "tao/taiwan"
  
  namespace :admin do
    get "categories/index"
    post "categories/index"
    resources :categories
    get "topics/index"
    post "topics/index"
    get "topics/null"
    post "topics/null"
    resources :topics
    get "posts/index"
    post "posts/index"
    get "posts/all"
    post "posts/all"
    get "posts/import"
    post "posts/import"
    get "posts/get_article"
    get "posts/set_cover"
    get "posts/get_post"
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
