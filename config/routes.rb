Rails.application.routes.draw do
  root to: 'visitors#index'

  resources :highlights, only: %i(create update destroy)
  resources :users

  # Findings
  get '/finding/:permalink'      => 'findings#show',  as: :finding

  # Follow / unfollow
  get '/follow/:id'              => 'followings#follow'
  get '/unfollow/:id'            => 'followings#unfollow'

  # User settings
  get '/settings'                => 'users#settings'

  # OAuth failure (for all strategies)
  get '/auth/failure'            => 'sessions#failure'

  # Twitter authentication
  get '/signin'                  => 'sessions#new',     as: :signin
  get '/signout'                 => 'sessions#destroy', as: :signout
  get '/auth/twitter/callback'   => 'sessions#create'

  # Evernote connect
  get '/evernote/connect'        => 'evernote#new'
  get '/evernote/sync'           => 'evernote#sync',     as: :sync_evernote
  get '/auth/evernote/callback'  => 'evernote#create'
end
