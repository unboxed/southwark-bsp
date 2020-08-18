Rails.application.routes.draw do
  root to: "homes#show", via: :get

  resources :survey_replies, only: [:new]

  get "start_survey", to: "surveys/start_surveys#new", as: :start_survey

  resources :surveys do
    resources :building_tenures, controller: "surveys/building_tenures"
    resources :building_statuses, controller: "surveys/building_statuses"
  end
end
