Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  devise_for :users, only: :sessions, module: :admin

  root to: "surveys#index"
  get "/help", to: "pages#help"

  namespace :admin do
    get "/", to: "dashboards#show"

    devise_scope :user do
      get "sign_in", to: "sessions#new"
      delete "sign_out", to: "sessions#destroy"
    end

    resource :dashboard, only: [:show]
    resources :buildings, only: [:new, :create, :edit, :update] do
      resources :notifications, only: [:create]
    end
    resources :bulk_imports, only: [:new, :create]
  end

  namespace :callbacks do
    resources :notification_statuses, only: [:create], constraints: lambda { |request| request.format == :json }
  end

end
