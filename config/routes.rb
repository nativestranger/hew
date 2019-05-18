Rails.application.routes.draw do
  root 'pages#home'
  get 'example', to: 'pages#example'
end
