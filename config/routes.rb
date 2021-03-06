Codestats::Application.routes.draw do
  root to: 'landing#index'
  devise_for :users, controllers: {
    omniauth_callbacks: 'omniauth_callbacks',
    invitations: 'invitations'
  }

  resources :users, only: [:show, :edit, :update]

  resources :organizations do
    resources :projects do
      member do
        get 'badge', to: 'badges#index'
      end
      resources :branches, only: [:index, :show] do
        resources :metrics, only: [] do
          collection do
            get 'chart_data', to: 'metrics#chart_data'
          end
        end
      end
    end
    resources :teams do
      resources :users, only: [:create, :destroy], controller: :teams_users
      resources :projects, only: [:create, :destroy], controller: :teams_projects
    end
    resources :github_link, only: [:new, :create], controller: :organizations_github_link do
      collection do
        delete :unlink
      end
    end
  end

  resources :github_pull_requests, only: [:create]

  # API Endpoints
  api_version(module:  'api/v1', path: { value: 'api/v1' }, defaults: { format: :json }) do
    resources :metrics, only: [:create]
  end

  require 'sidekiq/web'
  mount Sidekiq::Web, at: 'sidekiq'
end
