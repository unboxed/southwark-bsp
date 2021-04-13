module Survey
  module Sections
    class BaseForm
      include ActiveModel::Model
      include ActiveModel::Attributes
      include ActiveModel::Validations::Callbacks
      include Survey::BeforeTypeCast
      include Survey::Persistence
      include Survey::Naming

      delegate :completed, :completed=, to: :record
      delegate :stage, :goto, :next_stage, to: :record

      after_save do
        if next_stage && next_stage != stage
          goto(next_stage)
        end
      end

      def relevant?
        true
      end
    end
  end
end
