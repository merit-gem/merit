DummyMongoid::Application.routes.draw do
  resources :users, :except => :update
  resources :registrations, :only => :update, :as => :registrations_user
  resources :comments

  match '/comments/:id/vote/:value' => 'comments#vote', :value => /\d+/

  root :to => 'users#index'
end
