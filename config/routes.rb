Rails.application.routes.draw do
  resources :events
  devise_for :users
  resources :dishes
  root 'home#index'
  get 'dishes/index'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
