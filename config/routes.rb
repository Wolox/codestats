Codestats::Application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }
  root to: 'projects#index'

  resources :organizations, only: [:edit, :update]
  resources :projects, only: [:new, :create, :show, :index]

  require 'sidekiq/web'
  mount Sidekiq::Web, at: 'sidekiq'
  mount PgHero::Engine, at: 'pghero'
end
