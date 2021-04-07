module Survey
  module Sections
    class CheckYourAnswersForm < BaseForm
      attribute :completed, :boolean

      class << self
        def build(attributes)
          super.tap { |f| f.record.update({ completed: true }) }
        end
      end
    end
  end
end
