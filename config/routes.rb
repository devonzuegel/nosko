Rails.application.routes.draw do
  root to: 'visitors#index'
  get '/activity' => 'visitors#activity',   as: :activity

  resources :highlights, only: %i(create update destroy)
  resources :users

  # Findings
  get   '/finding/:permalink'        => 'findings#show',   as: :finding
  patch '/finding/:permalink'        => 'findings#update'
  get   '/finding/:permalink/lock'   => 'findings#lock',   as: :lock_finding
  get   '/finding/:permalink/unlock' => 'findings#unlock', as: :unlock_finding

  # Follow / unfollow
  get '/follow/:id'              => 'followings#follow'
  get '/unfollow/:id'            => 'followings#unfollow'

  # Friend / unfriend
  get '/friend/:id'              => 'friendships#friend'
  get '/unfriend/:id'            => 'friendships#unfriend'

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

  # Facebook authentication
  get '/facebook/connect'        => 'facebook#new'
  get '/auth/facebook/callback'  => 'facebook#create'

  # Facebok messenger bot webook
  mount Messenger::Bot::Space    => "facebook/webhook"
end
