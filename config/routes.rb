Rails.application.routes.draw do
  resources :sharings
  resources :highlights
  resources :findings
  resources :users

  root to: 'visitors#index'

  get '/settings'                => 'users#settings'

  get '/auth/failure'            => 'sessions#failure'

  get '/signin'                  => 'sessions#new',     as: :signin
  get '/signout'                 => 'sessions#destroy', as: :signout
  get '/auth/twitter/callback'   => 'sessions#create'

  get '/evernote/connect'        => 'evernote#new'
  get '/auth/evernote/callback'  => 'evernote#create'
end
