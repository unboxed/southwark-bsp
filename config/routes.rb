Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: "surveys#index"
  get "new_survey/:building_id", to: "surveys#new", as: "new_survey"
end
