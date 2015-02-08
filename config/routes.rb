require 'sidekiq/web'
require 'sidetiq/web'

Agileista::Application.routes.draw do
  constraint = lambda { |request| request.env["warden"].authenticate? && request.env['warden'].user.admin? }
  constraints constraint do
    mount Sidekiq::Web => '/sidekiq'
  end

  devise_for :people

  resources :projects, only: [:index, :edit, :update, :new, :create, :destroy] do
    resources :hip_chat_integrations, only: [:create, :update]
    resources :slack_integrations, only: [:create, :update]
    resources :team_members, only: [:destroy]
    resources :invitations, only: [:new, :create, :destroy]
    resource :search, only: 'show'
    resources :subscriptions, only: [] do
      collection do
        post 'on'
        post 'off'
      end
    end
    resources :backlog, only: 'index' do
      collection do
        post 'sort'
        delete 'destroy_multiple'
      end
    end

    resources :people, only: [:index]
    resources :sprints do
      member do
        get 'plan'
        post 'set_stats'
        get 'review'
      end
      resources :user_stories, only: [] do
        member do
          post 'plan'
          post 'unplan'
          post 'reorder'
        end
      end
    end

    resources :user_stories, except: [:index] do
      member do
        patch 'estimate'
        post 'copy'
      end

      resources :acceptance_criteria, only: [:update]

      resources :tasks, only: [:create, :destroy] do
        member do
          put 'claim'
          put 'renounce'
          put 'complete'
        end
      end
    end
  end

  get "/p/:project_id/stop/:id" => "subscriptions#stop"

  get "/about" => "about#index"
  root :to => "about#index"
end
