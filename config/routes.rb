Rails.application.routes.draw do
  resources :sharings
  resources :highlights
  resources :findings
  resources :users
  root to: 'visitors#index'
  get '/settings' => 'users#settings'

  get '/auth/:provider/callback' => 'sessions#create'
  get '/signin'                  => 'sessions#new',     as: :signin
  get '/signout'                 => 'sessions#destroy', as: :signout
  get '/auth/failure'            => 'sessions#failure'
end
