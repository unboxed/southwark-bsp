module Admin
  class AdminController < ApplicationController
    before_action :authenticate_admin!, unless: :devise_controller?
  end
end
