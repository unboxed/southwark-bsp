Rails.application.routes.draw do
  devise_for :users, only: %i(sessions confirmations passwords)
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: "surveys#index"

  get "new_survey", to: "surveys/start_surveys#new", as: :start_new_survey

  resources :frequently_asked_questions, only: %i(index)

  resources :surveys do
    resources :building_statuses, controller: "surveys/building_statuses"
    resources :building_tenures, controller: "surveys/building_tenures"
    resources :building_ownerships, controller: "surveys/building_ownerships"
  end
end
