require "ostruct"

class CollectionType < ActiveModel::Type::Value
  attr_reader :collection_class, :item_class

  def initialize(item: OpenStruct, collection: Array)
    @collection_class = collection
    @item_class = item
  end

  def type
    :collection
  end

  def cast(value)
    collection_class.new(build_items(value))
  end

  private

  def build_items(items)
    Array(items).map { |attributes| item_class.new(attributes) }
  end
end
