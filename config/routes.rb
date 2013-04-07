Agileista::Application.routes.draw do
  mount SecureResqueServer.new, :at => '/resque'
  devise_for :people

  get "/console" => "console#index"
  get "/health" => "health#index"
  post "/account/generate_api_key" => "account#generate_api_key"

  resources :projects do
    resources :hip_chat_integrations
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
        get 'review'
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
      end

      resources :acceptance_criteria, :only => [:update]

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

  get '/about' => 'about#index'
  root :to => "projects#index"
end
