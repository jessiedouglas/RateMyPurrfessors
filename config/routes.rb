Rails.application.routes.draw do
  root to: "root#home"
  get "search", as: "search", to: "root#search"

  resource :session, only: [:new, :create, :destroy]

  resources :users, except: [:index, :destroy]
  
  resources :colleges, only: [:index, :show] do
    resources :college_ratings, only: [:new, :create]
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
  resources :college_ratings, only: [:edit, :update, :destroy]
  resources :up_down_votes, only: [:create, :destroy]
  
  namespace 'api', defaults: { format: :json } do
    get "search", as: "search", to: "root#search"
    
    resources :colleges, only: [:index, :show] do
      resources :college_ratings, only: [:create]
      collection do
        get 'search'
      end
    end

    resources :professors, only: [:index, :show, :new, :create] do
      resources :professor_ratings, only: [:create]
      collection do
        get 'search'
      end
    end
  
    resources :professor_ratings, only: [:show, :update, :destroy]
    resources :college_ratings, only: [:show, :update, :destroy]
    resources :up_down_votes, only: [:create, :destroy] do 
      collection do 
        get 'find_vote'
      end
    end
  end
  
  get '/auth/facebook/callback', to: 'oauth#facebook'
end
