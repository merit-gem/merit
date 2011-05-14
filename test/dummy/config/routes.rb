Dummy::Application.routes.draw do
  resources :users, :comments

  match '/comments/:id/vote' => 'comments#vote', :id => /\d+/

  root :to => 'users#index'
end
