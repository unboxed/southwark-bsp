module Survey
  module Naming
    extend ActiveSupport::Concern

    module ClassMethods
      def model_name
        @_model_name ||= ActiveModel::Name.new(self, nil, "Survey")
      end
    end

    def to_partial_path
      "surveys/#{stage}_form"
    end
  end
end
