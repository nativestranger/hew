# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :admin do
    resources :users
    resources :calls
    resources :call_applications
    root to: "users#index"
    get 'blazer', to: 'application#blazer'
  end

  authenticated :user, ->(user) { user.is_admin? } do
    mount Blazer::Engine, at: "blazer"
  end

  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?

  root 'pages#home'

  devise_for :users, controllers: {
    confirmations: 'users/confirmations'
  }

  resources :carousels

  match 'images/:id', via: :get, to: 'public_carousel_images#show', as: :public_carousel_image
  match 'works/:id', via: :get, to: 'public_carousels#show', as: :public_carousel # TODO: is a work always a body/carousel?

  resources :chats, only: :show
  resources :venues, except: :destroy
  resources :calls, except: :destroy

  match 'calls/:id/applications', via: :get, to: 'calls#applications', as: :call_applications
  match 'calls/:id/applications/:call_application_id', via: :patch, to: 'calls#update_application_status', as: :update_call_application_status
  match 'calls/:id/details', via: :get, to: 'public_calls#details', as: :public_call_details

  resources :call_applications, only: %i[new create]
  get '/application_submitted', to: 'pages#application_submitted', as: :application_submitted

  get 'messages', to: 'pages#messages', as: :messages
  get 'dashboard', to: 'pages#dashboard', as: :dashboard

  get 'settings/profile', to: 'settings#profile'
  patch 'settings/profile', to: 'settings#update_profile', as: :update_profile_settings

  namespace :v1 do
    resources :carousels, only: [] do
      resources :carousel_images, only: %i[create destroy]
    end
    get '/chats/:id/messages' => "chats#messages", as: :chat_messages
    post '/chats/:id/create_message' => "chats#create_message", as: :chat_create_message
  end

  get 'artists/:user_id/profile' => "artists#profile", as: :artist_profile
end
