module Garnish
  module Presenter
    extend ActiveSupport::Concern
    include Garnish::Presenter::Relationships

    included do
      attr_accessor :record
      attr_accessor :template
      attr_accessor :record_class
    end

    module InstanceMethods
      def initialize(record, template)
        @record = record
        @template = template
        @record_class = record.class
      end

      def respond_to?(method, include_private = false)
        if select_methods.include?(method)
          record.respond_to?(method)
        else
          super
        end
      end

      protected

      def method_missing(*args, &block)
        begin
          # Check the record being presented first
          # If method doesn't exists check the template for helper convenience
          @record.send(*args, &block)
        rescue NoMethodError
          @template.send(*args, &block)
        end
      end
    end

    module ClassMethods
      def method_missing(method, *args, &block)
        record_class.send(method, *args, &block)
      end
    end

  end
end
