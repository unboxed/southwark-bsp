Rails.application.routes.draw do
  resources :building_managers
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: "building_managers#index"
end
