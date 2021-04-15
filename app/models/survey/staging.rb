require "set"

module Survey
  module Staging
    extend ActiveSupport::Concern

    included do
      class_attribute :initial_stage, instance_writer: false
      class_attribute :stages, instance_writer: false, default: Set.new
      class_attribute :transitions, instance_writer: false, default: Hash.new { Set.new }
      class_attribute :guards, instance_writer: false, default: []

      attribute :next_stage, :string

      define_model_callbacks :transition
      before_transition :validate_transition
    end

    class Guard
      attr_reader :block

      def initialize(from, to, block)
        @from  = Array(from)
        @to    = Array(to)
        @block = block
      end

      def match?(from, to)
        match_from?(from) && match_to?(to)
      end

      private

      def match_from?(from)
        @from.empty? || @from.include?(from)
      end

      def match_to?(to)
        @to.empty? || @to.include?(to)
      end
    end

    module ClassMethods
      def stage(name, initial: false)
        if initial
          self.initial_stage = name
        end

        stages << name
      end

      def transition(from:, to:)
        transitions[from] += [from] + Array(to)
      end

      def guard(from: nil, to: nil, &block)
        guards << Guard.new(from, to, block)
      end
    end

    def first_stage?
      stage == initial_stage
    end

    def current_stage?(name)
      stage == name
    end

    def can_transition?(from:, to:)
      return false unless stages.include?(to)
      return false unless transitions[from].include?(to)

      select_guards(from, to).all? do |guard|
        instance_exec(&guard.block)
      end
    end

    private

    def validate_transition
      return unless stage_changed?

      unless can_transition?(from: stage_was, to: stage)
        throw :abort
      end
    end

    def select_guards(from, to)
      guards.select { |guard| guard.match?(from, to) }
    end
  end
end
