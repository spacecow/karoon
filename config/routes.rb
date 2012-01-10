Karoon::Application.routes.draw do
  get 'logout' => 'sessions#destroy'
  get 'login' => 'sessions#new'
  resources :sessions, :only => [:new,:create,:destroy]

  get 'signup' => 'users#new'
  resources :users, :only => [:new,:create]

  get 'welcome' => 'books#index'
  resources :books
  root :to => 'books#index'

  resources :settings, :only => [:edit,:update]

  resources :authors
  resources :categories
end
