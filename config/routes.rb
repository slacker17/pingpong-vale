Rails.application.routes.draw do
  devise_for :users
  root to: "home#index"
  get '/history', to: 'home#history'
  get '/log',     to: 'home#new'
  get '/index',   to: 'home#index'
  post '/create', to: 'home#create'
end
