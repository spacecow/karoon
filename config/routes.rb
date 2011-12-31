Karoon::Application.routes.draw do
  get 'login' => 'sessions#new'
  resources :sessions, :only => [:new]

  get 'signup' => 'users#new'
  resources :users, :only => [:new,:create]

  get 'welcome' => 'books#index'
  resources :books, :only => [:index,:new]
  root :to => 'books#index'
end
