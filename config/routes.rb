Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
  resources :organizations, only: [ :index, :show ]
  resources :users, only: [ :new, :create ]

  get    '/signup', to: 'users#new'
  post   '/signup', to: 'users#create'

  get    '/login',  to: 'sessions#new'
  post   '/login',  to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  namespace :admin do
    get '/', to: 'dashboard#index', as: :dashboard
     resources :users
     resources :spaces
  end

  resource :parental_consent, only: [] do
    post :create_or_update
  end

  resources :spaces do
    member do
      post :join
    end
  end

  root "pages#home"
  get '/dashboard', to: 'dashboard#index'

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
