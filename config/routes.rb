Rails.application.routes.draw do
  resources :sessions
  resources :users
  resources :questions do
    resources :answers
  end

  root "pages#index"
  get 'set_locale/:locale', to: 'locales#set_locale', as: :set_locale
  
  namespace :admin do
    resources :users
  end

  

  # get 'sign_up', to: 'users#new', as: 'sign_up'
  # get 'sign_in', to: 'sessions#new', as: 'sign_in'
  # post 'sign_in', to: 'sessions#create'
  # delete 'sign_out', to: 'sessions#destroy', as: 'sign_out'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
end
