Rails.application.routes.draw do
  root to: "root#home"

  resource :session, only: [:new, :create, :destroy]

  resources :users, except: [:index, :destroy]

  resources :colleges, only: [:index, :show] do
    collection do
      get 'search'
    end
  end

  resources :professors, only: [:index, :show, :new, :create] do
    resources :professor_ratings, only: [:new, :create]
    collection do
      get 'search'
    end
  end
  
  resources :professor_ratings, only: [:edit, :update, :destroy]
end
