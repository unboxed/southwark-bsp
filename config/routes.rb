Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  devise_for :users, only: :sessions, module: :admin

  root to: "surveys#index"

  namespace :admin do
    get "/", to: "dashboards#show"

    devise_scope :user do
      get "sign_in", to: "sessions#new"
      delete "sign_out", to: "sessions#destroy"
    end

    resource :dashboard, only: [:show]
    resources :buildings, only: [:new, :create, :edit, :update]
    resources :bulk_imports, only: [:new, :create]
  end

  get "new_survey", to: "surveys/start_surveys#new", as: :start_new_survey
  get "get_started", to: "surveys#new", as: :get_started

  resources :surveys do
    resources :building_statuses, controller: "surveys/building_statuses"
    resources :building_tenures, controller: "surveys/building_tenures"
    resources :building_ownerships, controller: "surveys/building_ownerships"
    resources :building_heights, controller: "surveys/building_heights"
    resources :building_external_wall_structures, controller: "surveys/building_external_wall_structures" do
      resources :material_detail_lists, controller: "surveys/external_walls_material_details"
    end
    resources :building_walls, controller: "surveys/building_walls" do
      get "/edit", to:  "surveys/materials#edit"
      patch "/edit", to:  "surveys/materials#update", as: :material_edit
      resources :materials, controller: "surveys/materials"
      resources :percentages, controller: "surveys/percentages"
      resources :insulations, controller: "surveys/insulations"
    end
    resource :summary, controller: "surveys/summaries", only: [:show]
    post :end_survey, to:  "surveys#show"
    get :end_survey, to:  "surveys#show"
  end
end
