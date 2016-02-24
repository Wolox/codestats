Codestats::Application.routes.draw do
  root to: 'landing#index'
  devise_for :users, controllers: {
    omniauth_callbacks: 'omniauth_callbacks',
    invitations: 'invitations'
  }

  resources :organizations do
    member do
      get :link_to_github
      post :unlink_github
    end
    resources :projects, only: [:new, :create, :show, :index] do
      resources :branches, only: [:index, :show]
    end
    resources :teams do
      member do
        post :delete_user
        post :delete_project
        post :add_user
        post :add_project
      end
    end
  end

  # API Endpoints
  api_version(module:  'api/v1', path: { value: 'api/v1' }, defaults: { format: :json }) do
    resources :metrics, only: [:create]
  end

  require 'sidekiq/web'
  mount Sidekiq::Web, at: 'sidekiq'
  mount PgHero::Engine, at: 'pghero'
end
