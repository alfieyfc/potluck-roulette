Rails.application.routes.draw do
  resources :events
  devise_for :users
  resources :dishes
  root 'home#index'
  get 'dishes/index'
  post 'events/:id/join', to: 'events#join', as: 'join_event'
  post 'events/:id/leave', to: 'events#leave', as: 'leave_event'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
