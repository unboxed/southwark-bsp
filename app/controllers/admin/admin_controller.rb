module Admin
  class AdminController < ApplicationController
    before_action :authenticate_user!, unless: :devise_controller?
  end
end
