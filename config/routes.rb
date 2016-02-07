Codestats::Application.routes.draw do

  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }
  root to: 'application#index'

  resources :organizations, only: [:edit, :update]

  require 'sidekiq/web'
  mount Sidekiq::Web, at: 'sidekiq'
  mount PgHero::Engine, at: 'pghero'
end
