class SurveysController < ApplicationController
  before_action :find_survey

  rescue_from Survey::RecordNotFound do
    redirect_to new_survey_url
  end

  def edit
    respond_to do |format|
      format.html
    end
  end

  def update
    if @survey.update(survey_params)
      redirect_to survey_path
    else
      respond_to do |format|
        format.html { render :edit }
      end
    end
  end

  def destroy
    reset_session
    redirect_to survey_path
  end

  def goto
    @survey.goto(section_param)
    redirect_to survey_path
  end

  private

    def find_survey
      @survey = Survey.find(session.id)
    end

    def survey_params
      params.require(:survey)
    end

    def section_param
      params[:section].to_s
    end
end
