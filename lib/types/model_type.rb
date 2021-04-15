class ModelType < ActiveModel::Type::Value
  attr_reader :model_class

  def initialize(model:)
    @model_class = model
  end

  def type
    :model
  end

  def cast(value)
    model_class.new(value.as_json)
  end
end
