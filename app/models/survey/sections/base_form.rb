module Survey
  module Sections
    class BaseForm
      include ActiveModel::Model
      include ActiveModel::Attributes
      include ActiveModel::Validations::Callbacks
      include Survey::BeforeTypeCast
      include Survey::Persistence
      include Survey::Naming
      include Survey::NestedAttributes

      delegate :completed, :completed=, to: :record
      delegate :stage, :stage=, :stage_was, to: :record
      delegate :summaries, to: :record
      delegate :can_overwrite?, to: :record

      define_model_callbacks :transition

      after_save do
        if next_stage && next_stage != stage
          goto(next_stage)
        end
      end

      def goto(name)
        self.stage = name

        run_callbacks :transition do
          record.run_callbacks :transition do
            record.save
          end
        end
      end

      def next_stage
        stage
      end
    end
  end
end
