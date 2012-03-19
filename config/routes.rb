Agileista::Application.routes.draw do
  # resources :backlog, :controller => 'backlog', :collection => {:feed => :get, :search => :get, :sprint => :get, :sort => :post, :grid => :get, :list => :get}, :except => [:show]

  get "/backlog/:filter" => "backlog#index"
  get "/backlog/:filter/:range" => "backlog#index"

  resources :sprints do
    member do
      get 'plan'
    end
    resources :user_stories do
      member do
        post 'plan'
        post 'unplan'
        post 'reorder'
      end
    end
  end

  resources :impediments do
    member do
      post 'resolve'
    end
    collection do
      get 'active'
      get 'resolved'
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
      end
      collection do
        post 'create_quick'
        post 'assign'
      end
    end
  end

  resources :themes do
    collection do
      post 'sort'
    end
    resources :user_stories
  end

  resources :users

  get "/login" => "login#index"
  post "/login/authenticate" => "login#authenticate"

  get "/backlog" => "backlog#index"
  post "/backlog/sort" => "backlog#sort"
  get "/backlog/search" => "backlog#search"


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
