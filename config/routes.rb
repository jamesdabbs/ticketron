Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: :omniauth_callbacks }

  resources :concerts, only: [:index, :create] do
    resources :tickets, only: [:update]
  end
  resources :artists, only: [:index, :show] do
    collection do
      post :lookup_spotify_id, as: :spot
    end
  end
  resource :playlist, only: [:update, :show]

  post 'home' => 'voice#home'

  root to: 'concerts#index'
end
