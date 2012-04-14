Agileista::Application.routes.draw do
  map.resources :backlog, :controller => 'backlog', :collection => {:feed => :get, :search => :get, :sprint => :get, :sort => :post, :grid => :get, :list => :get}, :except => [:show]
  map.connect 'backlog/:filter', :controller => 'backlog', :action => 'index'
  map.connect 'backlog/:filter/:range', :controller => 'backlog', :action => 'index'

  map.resources :sprints, :member => { :plan => :get } do |sprint|
    sprint.resources :user_stories, :member => {:plan => :post, :unplan => :post, :reorder => :post}
  end

  map.resources :impediments, :member => {:resolve => :post}, :collection => {:active => :get, :resolved => :get}

  map.resources :user_stories, :member => {:copy => :post, :create_task => :post} do |user_story|
    user_story.resources :tasks, :member => {:move_up => :post, :move_down => :post, :claim => :put}, :collection => {:create_quick => :post, :assign => :post}
  end

  map.resources :themes, :collection => {:sort => :post} do |theme|
    theme.resources :user_stories
  end

  map.resources :users


  # The priority is based upon order of creation: first created -> highest priority.
  
  # Sample of regular route:
  # map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  # map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # You can have the root of your site routed by hooking up '' 
  # -- just remember to delete public/index.html.
  map.root :controller => "signup"

  # Allow downloading Web Service WSDL as a file with an extension
  # instead of a file named 'wsdl'
  map.connect ':controller/service.wsdl', :action => 'wsdl'

  # Install the default route as the lowest priority.
  # map.connect ':account_name/:controller/:action/:id'
  # map.connect ':account_name', :controller => "backlog"

  map.connect ':controller/:action/:id'
end