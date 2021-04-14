class ListType < ActiveModel::Type::Value
  attr_reader :values

  def initialize(values: [])
    @values = values
  end

  def type
    :list
  end

  def cast(value)
    Array(value).reject do |item|
      next true unless item.is_a?(String)
      next true if item.blank?
      next true unless values.empty? || values.include?(item)

      false
    end
  end
end
