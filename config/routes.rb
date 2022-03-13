Rails.application.routes.draw do
  get 'tweets/create'
  get 'tweets/edit'
  get 'tweets/update'
  get 'tweets/destroy'
  get 'relationships/create'
  get 'relationships/destroy'
  devise_for :users, controllers: {registrations: 'registrations'}
  resources :tweets, only: [:create, :edit, :update, :destroy]
  resources :users, only: [:index,:show] do
    member do
      get :following
      get :followers
    end
  end
  get 'tweeters', to: 'users#index'
  resources :relationships, only: [:create, :destroy]
  get 'pages/timeline'
  root "pages#timeline"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
