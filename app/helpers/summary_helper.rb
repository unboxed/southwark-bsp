module SummaryHelper
  def form_for_stage(stage)
    build_for_stage(@survey.record, stage)
  end

  def stages_with_forms
    stages = @survey.all_stages
               .reject { |s| ["check_your_answers", "complete"].include? s }

    forms = stages
              .map { |s| form_for_stage(s) }

    stages.zip(forms)
  end

  def no_value(value)
    value.nil? || value == ""
  end

  def summary_format(value)
    formatted = case value
                when String
                  if value == "true"
                    "Yes"
                  elsif value == "false"
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

  def build_for_stage(record, stage)
    form(stage).build(record)
  end

  def form(stage)
    "Survey::Sections::#{stage.camelize}Form".safe_constantize
  end
end
