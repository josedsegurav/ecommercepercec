Rails.application.routes.draw do

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  resources :order_items
  resources :orders, only: [:index, :show]
  resources :order_verifications, only: [:show], path: 'orders/:id/verify', as: :verify_order do
    member do
      post :verify
    end
  end
  resources :stock_movements
  resources :products, only: [:index, :show]
  resources :vendors
  resources :categories, only: [:index, :show]
  resources :users
  resources :home
  resources :cart, only: [:index] do
    post 'add/:product_id', to: 'cart#add', as: 'add', on: :collection
    post 'checkout', to: 'cart#checkout', on: :collection
    patch 'update_item', to: 'cart#update_item', on: :collection
    delete 'remove_item', to: 'cart#remove_item', on: :collection
    delete 'clear', to: 'cart#clear', on: :collection

  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "home#index"
end
