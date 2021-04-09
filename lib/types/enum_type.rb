class EnumType < ActiveModel::Type::Value
  attr_reader :values

  def initialize(values: [])
    @values = values
  end

  def type
    :enum
  end

  def cast(value)
    return nil unless value.is_a?(String)
    return nil unless values.include?(value)

    value
  end
end
