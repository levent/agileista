Agileista::Application.routes.draw do
  # resources :backlog, :controller => 'backlog', :collection => {:feed => :get, :search => :get, :sprint => :get, :sort => :post, :grid => :get, :list => :get}, :except => [:show]

  get "/backlog/:filter" => "backlog#index"
  get "/backlog/:filter/:range" => "backlog#index"

  resources :sprints, :member => { :plan => :get } do
    resources :user_stories, :member => {:plan => :post, :unplan => :post, :reorder => :post}
  end

  resources :impediments, :member => {:resolve => :post}, :collection => {:active => :get, :resolved => :get}

  resources :user_stories, :member => {:copy => :post, :create_task => :post} do
    resources :tasks, :member => {:move_up => :post, :move_down => :post, :claim => :put}, :collection => {:create_quick => :post, :assign => :post}
  end

  resources :themes, :collection => {:sort => :post} do
    resources :user_stories
  end

  resources :users

  get "/login" => "login#index"
  post "/login/authenticate" => "login#authenticate"

  get "/backlog" => "backlog#index"
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
