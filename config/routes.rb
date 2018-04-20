Rails.application.routes.draw do
  resources :nodes
  resources :blocks, only: %i[show index]
  resources :transactions, only: %i[new create index show]

  post 'nodes/register', to: 'nodes#register', as: 'register'
  get '/mine', to: 'mine#mine', as: 'mine'
  get 'index/index'
  root 'index#index'

  get '/events', to: 'events#index'
end
