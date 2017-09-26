Rails.application.routes.draw do

  devise_for :users, :path_names => {:sign_in => "login"},  :controllers => {omniauth_callbacks: "omniauth_callbacks"}

  root 'pages#home'
  get '/auth/:provider/callback', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy', as: :logout
  delete '/videos/', to: 'videos#destroy'
  get '/videos/#:video.id', :controller=>'videos', :action=>'update'
  delete '/videos/#:video.id',:controller=>'videos',:action=>'delete'
  get 'your-videos', to: 'videos#your_videos'
  get 'your-subjects', to: 'subjects#your_subjects'
  get 'search', to: 'pages#search'

  resources :videos do
    resources :comments, only: [:create]
  end
  resources :subjects
  resources :comments, only: [:create, :destroy]
  resources :suggestions, only: [:index, :create, :destroy]

end
