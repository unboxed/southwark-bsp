module SummaryHelper
  def stages_with_forms(survey)
    stages = survey
             .record.stages
             .reject { |s| ["check_your_answers", "complete"].include? s }

    forms = stages
            .map { |s| form_for_stage(survey, s) }

    stages.zip(forms)
  end

  def no_value(value)
    value.nil? || value == ""
  end

  def summary_format(value)
    formatted = case value
                when String
                  case value
                  when "true"
                    "Yes"
                  when "false"
                    "No"
                  else
                    value
                  end
                when Array
                  value.join(", ")
                else
                  value
                end

    if formatted.respond_to? :humanize
      formatted.humanize
    else
      formatted
    end
  end

  private

  def form_for_stage(survey, stage)
    form(stage).build(survey.record)
  end

  def form(stage)
    "Survey::Sections::#{stage.camelize}Form".safe_constantize
  end
end
