Rails.application.routes.draw do
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?

  devise_for :users
  root 'pages#home'
  get 'example', to: 'pages#example'

  get 'settings/profile', to: 'settings#profile'
  patch 'settings/profile', to: 'settings#update_profile', as: :update_profile_settings
end
