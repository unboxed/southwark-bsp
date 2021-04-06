module Survey
  module Sections
    class BaseForm
      include ActiveModel::Model
      include ActiveModel::Attributes
      include ActiveModel::Validations::Callbacks
      include Survey::BeforeTypeCast
      include Survey::Persistence
      include Survey::Staging
      include Survey::Naming
    end
  end
end
