Dummy::Application.routes.draw do
  resources :users, :comments

  match '/comments/:id/vote/:value' => 'comments#vote', :id => /\d+/, :value => /\d+/

  root :to => 'users#index'
end
