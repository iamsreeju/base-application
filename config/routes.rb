MyBase::Application.routes.draw do
  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'
  root :to => "home#index"

  devise_for :users, :controllers => {:registrations => "users/registrations", :omniauth_callbacks => "users/omniauth_callbacks"}, 
  :path => 'auth', :path_names => { :sign_in => "login", :sign_out => "logout", :sign_up => "register", :password => 'password' }
  
  resources :users
end