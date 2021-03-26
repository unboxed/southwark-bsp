Rails.application.routes.draw do

  root to: "surveys#index"
  get "/help", to: "pages#help"

  namespace :admin do
    get "/", to: "dashboards#show"


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
