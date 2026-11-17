Rails.application.routes.draw do
  resources :movies
  resources :customers
  resources :rentals, only: [:index, :show, :new, :create] do
    member do
      patch :return
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check

  root "home#index"
end
