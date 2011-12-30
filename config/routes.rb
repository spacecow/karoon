Karoon::Application.routes.draw do
  resources :books, :only => :index
  root :to => 'books#index'
end
