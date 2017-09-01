Rails.application.routes.draw do
  
  #devise_for :users, :path_names => {:sign_in => "login"}, :controllers => {omniauth_callbacks: "omniauth_callbacks"}
  #devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
  devise_for :users, :path_names => {:sign_in => "login"},  :controllers => {omniauth_callbacks: "omniauth_callbacks"}

  resources :subjects do
    collection do
      get 'search'
    end
    resources :subjects
  end

  resources :videos do
    collection do
      get 'search'
    end
    resources :videos
  end

  resources :comments, only: [:new, :create]

  resources :suggestions

  resources :video_uploads, only: [:new, :create]

  root to: 'pages#home'

  get '/auth/:provider/callback', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy', as: :logout

  get 'featured' => 'pages#featured'

  get 'oldest_to_new' => 'videos#oldest_to_new'
  get 'a_to_z' => 'videos#a_to_z'
  get 'z_to_a' => 'videos#z_to_a'
  get 'most_recent' => 'videos#most_recent'
  get 'highest_rating' => 'videos#highest_rating'

  get 'signup' => 'users#new'
  get 'login' => 'sessions#new'
  post 'login' => 'sessions#create'
  delete 'logout' => 'sessions#destroy'

  delete '/videos/', to: 'videos#destroy'
  get '/videos/#:video.id', :controller=>'videos', :action=>'update'
  delete '/videos/#:video.id',:controller=>'videos',:action=>'delete'

end
