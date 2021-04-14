Rails.application.routes.draw do
  root to: "pages#index"

  get "/help", to: "pages#help"

  controller "surveys" do
    get    "/survey/:section", action: "goto",    as: :goto
    get    "/survey",          action: "edit",    as: :survey
    post   "/survey",          action: "update",  as: nil
    delete "/survey",          action: "destroy", as: nil
  end

  devise_for :admin, only: :sessions, class_name: "User", module: "admin"

  namespace :admin do
    root to: "dashboards#show"

    resources :bulk_imports, only: [:new, :create]

    resources :buildings, only: [:new, :create, :edit, :update] do
      collection do
        put :bulk_update
      end
      resources :notifications, only: [:create]
    end
  end

  namespace :callbacks do
    resources :notification_statuses, only: [:create], constraints: lambda { |request| request.format == :json }
  end

  resolve("Survey") { [:survey] }
end
