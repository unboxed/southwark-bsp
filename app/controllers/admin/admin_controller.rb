module Admin
  class AdminController < ApplicationController
    before_action :authenticate_admin!, unless: :devise_controller?

    helper_method :return_path

    private

    def return_path
      if session["current_search"].present?
        admin_search_path(session["current_search"])
      else
        admin_root_path
      end
    end
  end
end
