module Survey
  module Persistence
    extend ActiveSupport::Concern

    included do
      class_attribute :permit_attributes, instance_writer: false

      attr_reader :record
      define_model_callbacks :save, :commit, :rollback
      define_model_callbacks :assign_record, only: :after

      delegate :building, :transaction, to: :record
      delegate :with_transaction_returning_status, to: :record

      validate :validate_record
    end

    module ClassMethods
      def new(attributes)
        super(slice(attributes))
      end

      def build(record)
        new(record.data).tap { |form| form.record = record }
      end

      private

        def slice(attributes)
          attributes.slice(*attribute_types.keys)
        end
    end

    def record=(value)
      run_callbacks :assign_record do
        @record = value
      end
    end

    def assign_attributes(attributes)
      super(permit(attributes))
    end

    def update(attributes)
      record.with_transaction_returning_status do
        assign_attributes(attributes)
        save
      end
    end

    def update!(attributes)
      record.with_transaction_returning_status do
        assign_attributes(attributes)
        save!
      end
    end

    def save(**options)
      unless options[:validate] == false
        return false unless valid?
      end

      run_callbacks :commit do
        save_in_transaction(options)
      end

      true
    end

    def save!(**options)
      save(options) || (raise RecordNotSaved, "Failed to save survey form")
    end

    private

      def permit(params)
        if params.respond_to?(:permit)
          params.permit(permitted_attributes)
        else
          params
        end
      end

      def permitted_attributes
        permit_attributes || attribute_names
      end

      def validate_record
        unless record.valid?
          errors.merge!(record.errors)
        end
      end

      def save_in_transaction(options)
        record.transaction do
          run_callbacks :save do
            record.assign_attributes(stored_attributes)
            record.save!(options)
          end
        end
      rescue Exception => e
        handle_transaction_rollback(e)
      end

      def stored_attributes
        attributes.slice(*record.form_attributes)
      end

      def handle_transaction_rollback(exception)
        run_callbacks :rollback
        raise exception
      end
  end
end
