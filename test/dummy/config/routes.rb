Dummy::Application.routes.draw do
  resources :users, :comments

  root :to => 'users#index'
end
