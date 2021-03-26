Rails.application.routes.draw do
  root to: "pages#index"

  get "/help", to: "pages#help"

  devise_for :admin, only: :sessions, class_name: "User", module: "admin"

  namespace :admin do
    root to: "dashboards#show"

    resources :bulk_imports, only: [:new, :create]

    resources :buildings, only: [:new, :create, :edit, :update] do
      resources :notifications, only: [:create]
    end
  end

  namespace :callbacks do
    resources :notification_statuses, only: [:create], constraints: lambda { |request| request.format == :json }
  end
end
