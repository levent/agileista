Agileista::Application.routes.draw do
  # resources :backlog, :controller => 'backlog', :collection => {:feed => :get, :search => :get, :sprint => :get, :sort => :post, :grid => :get, :list => :get}, :except => [:show]

  get "/console" => "console#index"
  get "/health" => "health#index"
  post "/backlog/sort" => "backlog#sort"
  get "/backlog/search" => "backlog#search"
  get "/backlog/grid" => "backlog#grid"
  get "/backlog/list" => "backlog#list"
  get "/backlog/:filter" => "backlog#index"
  get "/backlog/:filter/:range" => "backlog#index"

  post "/signup" => "signup#create"
  get "/validate" => "signup#validate"
  get "/ok" => "signup#ok"
  get "/account" => "account#index"
  put "/account/change_password" => "account#change_password"
  post "/account/generate_api_key" => "account#generate_api_key"
  put "/account/settings" => "account#settings"
  post "/account/resend_authentication" => "account#resend_authentication"

  resources :sprints do
    member do
      get 'plan'
    end
    member do
      post 'set_stats'
    end
    resources :user_stories do
      member do
        post 'plan'
        post 'unplan'
        post 'reorder'
      end
    end
  end

  resources :user_stories do
    member do
      post 'copy'
      post 'create_task'
    end
    resources :tasks do
      member do 
        post 'move_up'
        post 'move_down'
        put 'claim'
        put 'renounce'
        put 'complete'
      end
      collection do
        post 'create_quick'
      end
    end
  end

  resources :themes do
    resources :user_stories
  end

  resources :users

  get "/login" => "login#index"
  get "/login/forgot" => "login#forgot"
  post "/login/forgot" => "login#forgot"
  get "/logout" => "login#logout"
  post "/login/authenticate" => "login#authenticate"

  get "/backlog" => "backlog#index"


  # The priority is based upon order of creation: first created -> highest priority.
  
  # Sample of regular route:
  # connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  # map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # You can have the root of your site routed by hooking up '' 
  # -- just remember to delete public/index.html.
  root :to => "signup#index"
end
