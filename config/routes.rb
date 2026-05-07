Rails.application.routes.draw do
  devise_for :users

  resources :chats, only: %i[index show create destroy] do
    resources :messages, only: %i[create]
  end

  root to: "chats#index"

  # PWA routes
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
end
