class SurveysController < ApplicationController
  before_action :find_survey, except: :recover
  before_action :preset_uprn, :check_existing_survey, only: :edit

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

  def recover
    record = Survey::Record.find_by(token: params[:token])

    if record.nil?
      flash[:notification] = t(:survey_not_found, scope: "errors")
      redirect_to root_path and return
    elsif !record.can_overwrite?
      flash[:notification] = t(:survey_cannot_change, scope: "errors")
      redirect_to root_path and return
    end

    session.clear unless session.exists?

    record.reset!(session.id)

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

    def preset_uprn
      @survey.uprn = params[:uprn] if params[:uprn]
    end

    def check_existing_survey
      return true if @survey.can_overwrite? || @survey.stage == "complete"

      @survey.record.destroy
      flash[:notification] = t(:survey_protected, scope: "errors")

      redirect_to root_path and return
    end
end
