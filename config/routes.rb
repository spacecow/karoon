Karoon::Application.routes.draw do
  get 'logout' => 'sessions#destroy'
  get 'login' => 'sessions#new'
  resources :sessions, :only => [:new,:create,:destroy]

  get 'signup' => 'users#new'
  resources :users, :only => [:new,:create]

  get 'welcome' => 'books#index'
  resources :books do
    collection do
      post 'create_individual' 
    end
    member do
      get 'who_bought'
    end
  end
  root :to => 'books#index'

  resources :settings, :only => [:edit,:update]

  resources :authors
  resources :categories
  resources :searches, :only => [:show,:index,:create]

  resources :carts, :only => [:show,:update,:destroy]
  resources :line_items, :only => [:create]
  resources :orders, :only => [:new,:create,:edit,:update] do
    member do
      get 'validate'
      put 'confirm'
    end
  end
end
