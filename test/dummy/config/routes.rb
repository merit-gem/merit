Dummy::Application.routes.draw do
  namespace :admin do
    get '/users' => 'users#index'
  end
  namespace :api do
    get '/users' => 'users#index'
    resources :comments, only: [:show]
  end
  resources :users, :except => :update
  resources :registrations, :only => :update, :as => :registrations_user
  resources :comments

  get '/comments/:id/vote/:value' => 'comments#vote', :id => /\d+/, :value => /\d+/

  root :to => 'users#index'
end
