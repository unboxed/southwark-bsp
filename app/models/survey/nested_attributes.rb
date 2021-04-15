module Survey
  module NestedAttributes
    extend ActiveSupport::Concern

    module ClassMethods
      def accepts_nested_attributes_for(*names)
        names.each do |name|
          define_method :"#{name}_attributes=" do |attributes|
            send(name).assign_attributes(attributes)
          end
        end
      end
    end
  end
end
