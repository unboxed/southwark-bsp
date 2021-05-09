class PagesController < ApplicationController
  before_action :check_uprn_link, only: :index

  def index
    respond_to do |format|
      format.html
    end
  end

  def help
    respond_to do |format|
      format.html
    end
  end

  private

  def check_uprn_link
    return if params[:uprn].nil?

    redirect_to survey_url(uprn: params[:uprn])
  end
end
