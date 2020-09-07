Rails.application.routes.draw do
  devise_for :users, only: %i(sessions confirmations passwords)
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: "surveys#index"

  get "new_survey", to: "surveys/start_surveys#new", as: :start_new_survey

  resources :surveys do
    resources :building_statuses, controller: "surveys/building_statuses"
    resources :building_tenures, controller: "surveys/building_tenures"
    resources :building_ownerships, controller: "surveys/building_ownerships"
    resources :building_heights, controller: "surveys/building_heights"
    resources :building_external_wall_structures, controller: "surveys/building_external_wall_structures" do
      resources :material_detail_lists, controller: "surveys/external_walls_material_details"
    end
    resources :building_walls, controller: "surveys/building_walls" do
      patch "/materials", to:  "surveys/materials#update"
      get "materials/details", to:  "surveys/materials#material_partial"
      patch "materials/details", to:  "surveys/materials#update"
      resources :materials, controller: "surveys/materials"
    end
    resource :summary, controller: "surveys/summaries", only: [:show]
    resource :end_survey, controller: "surveys/end_surveys", only: [:create]
  end
end
