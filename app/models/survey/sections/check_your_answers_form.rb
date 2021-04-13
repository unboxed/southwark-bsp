module Survey
  module Sections
    class CheckYourAnswersForm < BaseForm
      before_save do
        record.completed_at = Time.current
      end
    end
  end
end
