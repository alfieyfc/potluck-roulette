Rails.application.routes.draw do
  devise_for :users
  resources :events, except: [:index]
  resources :dishes, except: [:index]
  root 'home#index'
  post 'events/:id/join', to: 'events#join', as: 'join_event'
  post 'events/:id/leave', to: 'events#leave', as: 'leave_event'
  get 'events/:id/draw', to: 'events#draw', as: 'draw_ingredient_style'
  get 'events/:id/reset', to: 'events#reset', as: 'reset_ingredient_style'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
