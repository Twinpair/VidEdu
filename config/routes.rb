Rails.application.routes.draw do
  get 'pages/index'

  get 'pages/home'

  get 'pages/about'

  get 'pages/subjects'

  get 'pages/profile'

  get 'pages/contact'

  get 'pages/featured'

  get 'pages/faq'

  get 'pages/splash'

# controller#method_name
  root to: 'pages#splash'
end
