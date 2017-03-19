require 'sidekiq/web'

Rails.application.routes.draw do
  use_doorkeeper

  devise_for :users, controllers: { omniauth_callbacks: :auth }
  devise_scope :user do
    get    '/users/sign_in'  => 'auth#login',  as: :new_user_session
    delete '/users/sign_out' => 'auth#logout', as: :destroy_user_session
  end

  resource :profile, only: [:show]
  resources :friends, only: [:index, :show, :create] do
    member do
      post :approve
    end
  end

  resources :concerts, only: [:index, :create, :show] do
    resource :tickets, only: [:update]
  end

  resource :spotify, only: [:update, :show]

  resources :mail, only: [:index, :show, :create] do
    member do
      post :retry
    end
  end

  resource :calendar, only: [:update]

  post 'home' => 'voice#home'

  root to: 'concerts#index'

  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/jobs'
  end

  if Rails.env.development?
    scope :dev do
      get 'login/:id' => 'dev#force_login'
    end
  end
end
