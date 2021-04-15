require "types/collection_type"
require "types/enum_type"
require "types/list_type"
require "types/model_type"

ActiveModel::Type.register :collection, CollectionType
ActiveModel::Type.register :enum, EnumType
ActiveModel::Type.register :list, ListType
ActiveModel::Type.register :model, ModelType
