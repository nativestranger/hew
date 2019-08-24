# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :admin do
    resources :users
    resources :carousels
    resources :carousel_images
    resources :cities
    resources :venues

    root to: "users#index"
  end
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?

  root 'pages#home'
  devise_for :users
  resources :carousels
  resources :venues, except: :destroy
  resources :shows, except: :destroy

  get 'settings/profile', to: 'settings#profile'
  patch 'settings/profile', to: 'settings#update_profile', as: :update_profile_settings

  namespace :v1 do
    resources :carousels, only: [] do
      resources :carousel_images, only: :create
    end
  end
end
