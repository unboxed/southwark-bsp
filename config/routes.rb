Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  devise_for :users, only: :sessions, module: :admin

  root to: "surveys#index"

  namespace :admin do
    devise_scope :user do
      get "sign_in", to: "sessions#new"
      delete "sign_out", to: "sessions#destroy"
    end
    get "/", to: "dashboards#show"
    resource :dashboard, only: [:show]
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
    resources :building_walls,  only: [:index, :create], controller: "surveys/building_walls" do
      resources :building_wall_materials, controller: "surveys/building_wall_materials"
      resources :building_wall_material_insulations, controller: "surveys/building_wall_material_insulations"
      resources :building_wall_material_percentages, controller: "surveys/building_wall_material_percentages"
    end
    resource :summary, controller: "surveys/summaries", only: [:show]
    post :end_survey, to:  "surveys#show"
    get :end_survey, to:  "surveys#show"
  end
end
