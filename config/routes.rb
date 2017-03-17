Rails.application.routes.draw do
  use_doorkeeper

  devise_for :users, controllers: { omniauth_callbacks: :auth }
  delete '/users/sign_out' => 'auth#logout', as: :destroy_user_session

  resource :profile, only: [:show]

  resources :concerts, only: [:index, :create] do
    resources :tickets, only: [:update]
  end
  resource :playlist, only: [:update, :show]

  resources :users, only: [:index, :show]

  resources :mail, only: [:index, :show, :create] do
    member do
      post :retry
    end
  end

  post 'home' => 'voice#home'

  root to: 'concerts#index'
end
