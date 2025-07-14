Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }
  root "home#index"
  
  get "parental_consent/pending"
  
  resources :organizations, only: [:index, :show, :new, :create] do
    member do
      post :join
      delete :leave
    end
    
    resources :contents, except: [:index]
  end
  
  # Global content index for user's content across all organizations
  resources :contents, only: [:index]
  
  # Admin routes
  namespace :admin do
    resources :parental_consent, only: [:index] do
      member do
        patch :approve
        patch :revoke
      end
    end
    
    resources :analytics, only: [:index]
    get 'analytics/organization/:id', to: 'analytics#organization', as: 'analytics_organization'
    
    root 'parental_consent#index'
  end
  
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
