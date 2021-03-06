module Survey
  class SurveyError < StandardError; end
  class RecordNotFound < SurveyError; end
  class RecordNotSaved < SurveyError; end
  class SectionNotFound < SurveyError; end
  class MaterialNotFound < SurveyError; end
  class SummaryNotFound < SurveyError; end

  mattr_accessor :table_name_prefix, instance_writer: false, default: "survey_"

  class << self
    def find(session_id)
      build(find_or_initialize(session_id))
    end

    def clear_previous_surveys(session_id)
      Survey::Record.where(session_id: session_id).update(session_id: nil)
    end

    private

    def build(record)
      form(record.stage).build(record)
    rescue NameError
      raise SectionNotFound, "Couldn't find form model for stage '#{record.stage}'"
    end

    def form(stage)
      "Survey::Sections::#{stage.camelize}Form".constantize
    end

    def find_or_initialize(session_id)
      Survey::Record.find_or_initialize_by(session_id: session_id.to_s)
    end
  end
end
