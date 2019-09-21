# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :admin do
    resources :users
    resources :shows
    resources :show_applications
    root to: "users#index"
  end

  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?

  root 'pages#home'

  devise_for :users

  resources :carousels
  match 'works/:id', via: :get, to: 'public_carousels#show', as: :public_carousel # TODO: is a work always a body/carousel?

  resources :chats, only: :show
  resources :venues, except: :destroy
  resources :shows, except: :destroy

  match 'shows/:id/applications', via: :get, to: 'shows#applications', as: :show_applications
  match 'shows/:id/applications/:show_application_id', via: :patch, to: 'shows#update_application_status', as: :update_show_application_status
  match 'shows/:id/details', via: :get, to: 'public_shows#details', as: :public_show_details

  resources :show_applications, only: %i[new create]
  get '/application_submitted', to: 'pages#application_submitted', as: :application_submitted

  get 'messages', to: 'pages#messages', as: :messages
  get 'dashboard', to: 'pages#dashboard', as: :dashboard

  get 'settings/profile', to: 'settings#profile'
  patch 'settings/profile', to: 'settings#update_profile', as: :update_profile_settings

  namespace :v1 do
    resources :carousels, only: [] do
      resources :carousel_images, only: :create
    end
    get '/chats/:id/messages' => "chats#messages", as: :chat_messages
    post '/chats/:id/create_message' => "chats#create_message", as: :chat_create_message
  end

  get 'artists/:user_id/profile' => "artists#profile", as: :artist_profile
end
