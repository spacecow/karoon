Karoon::Application.routes.draw do
  get 'logout' => 'sessions#destroy'
  get 'login' => 'sessions#new'
  resources :sessions, :only => [:new,:create,:destroy]

  get 'signup' => 'users#new'
  match 'signup_confirmation/:token' => 'users#signup_confirmation', :as => :signup_confirmation
  resources :users, :only => [:show,:new,:create] do
    collection do
      get :signup_confirmation
    end
  end

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
  resources :categories, :only => [:show,:index,:create,:update,:destroy]
  resources :searches, :only => [:show,:index,:create]

  resources :carts, :only => [:show,:update,:destroy]
  resources :line_items, :only => [:create,:destroy]
  resources :orders, :only => [:new,:create,:edit,:update,:show] do
    member do
      get 'validate'
      put 'confirm'
    end
  end

  resources :translations, :only => [:index,:create] do
    collection do
      put 'update_multiple'
    end
  end
  resources :locales, :only => :index
end
