Agileista::Application.routes.draw do
  devise_for :people

  # resources :backlog, :controller => 'backlog', :collection => {:feed => :get, :search => :get, :sprint => :get, :sort => :post, :grid => :get, :list => :get}, :except => [:show]

  get "/console" => "console#index"
  get "/health" => "health#index"
  # post "/backlog/sort" => "backlog#sort"
  # get "/backlog/search" => "backlog#search"
  # get "/backlog/grid" => "backlog#grid"
  # get "/backlog/list" => "backlog#list"
  # get "/backlog/:filter" => "backlog#index"
  # get "/backlog/:filter/:range" => "backlog#index"

  post "/account/generate_api_key" => "account#generate_api_key"

  resources :projects do
    resources :team_members
    resources :invitations
    resources :backlog, :only => 'index' do
      collection do
        get 'search'
        post 'sort'
      end
    end

    resources :people, :only => [:index]
    resources :sprints do
      member do
        get 'plan'
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

      resources :tasks, :except => [:edit, :update] do
        member do 
          post 'move_up'
          post 'move_down'
          put 'claim'
          put 'renounce'
          put 'complete'
        end
      end

    end
  end

  root :to => "projects#index"
end
