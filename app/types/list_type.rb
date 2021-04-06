class ListType < ActiveModel::Type::Value
  attr_reader :klass

  def initialize(klass)
    super()

    @klass = klass
  end
end
