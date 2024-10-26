Rails.application.routes.draw do
  root "pages#index"


  get "set_locale/:locale", to: "locales#set_locale", as: :set_locale

  resources :sessions, only: [ :new, :create, :destroy ]
  resources :password_resets, only: [ :new, :create, :edit, :update ]
  resources :account_activations, only: [ :edit ]


  resources :users, only: [ :new, :create, :edit, :update ]

  resources :questions do
    resources :comments, only: [ :create, :show, :destroy ]
    resources :answers, only: [ :create, :destroy ]
  end

  resources :answers do
    resources :comments, only: [ :create, :show, :destroy ]
  end

  namespace :admin do
    resources :users, only: [ :new, :create, :index, :show, :edit, :update, :destroy ]
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
end
