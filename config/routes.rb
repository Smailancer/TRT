Rails.application.routes.draw do
 
  devise_for :users, controllers: {registrations: 'registrations'}
  resources :tweets, only: [:create, :edit, :update, :destroy]
  resources :likes, only: [:create, :destroy], param: :likeable_id
  resources :comments, only: [:create, :destroy]
  resources :retweets, only: [:create, :destroy]
  resources :users, only: [:index,:show] do
    member do
      get :following
      get :followers
    end
  end
  post :notifications, to: 'notifications#mark_all_read'
  get 'tweeters', to: 'users#index'
  resources :relationships, only: [:create, :destroy]
  get 'pages/timeline'
  root "pages#timeline"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
