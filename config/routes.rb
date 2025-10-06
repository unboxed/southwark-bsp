Rails.application.routes.draw do
  root to: "pages#index"

  get "/help", to: "pages#help"

  controller "surveys" do
    get    "/survey/recover",  action: "recover"
    get    "/survey/:section", action: "goto",    as: :goto
    get    "/survey",          action: "edit",    as: :survey
    post   "/survey",          action: "update",  as: nil
    delete "/survey",          action: "destroy", as: nil
  end

  devise_for :admin, only: %i[sessions passwords], class_name: "User", module: "admin"

  namespace :admin do
    root to: "buildings#index"

    resource :search, only: [:show]

    scope "/buildings", as: "building" do
      resource :delta, only: [:update]

      resource :letters, only: [:create] do
        member do
          post :confirm
        end
      end
    end

    resources :bulk_imports, only: [:new, :create]

    resources :buildings, param: :uprn do
      nested do
        put :survey_state
      end
    end
  end

  namespace :callbacks do
    resources :notification_statuses, only: [:create], constraints: lambda { |request| request.format == :json }
  end

  resolve("Survey") { [:survey] }
end
