Rails.application.routes.draw do

  resources :blocks, only: [:show, :index]

  get '/mine', to:'mine#mine', as: 'mine'

  get 'index/index'

  root 'index#index'
end
