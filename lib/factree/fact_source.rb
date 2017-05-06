module Factree
  # Mixin to help define fact source classes.
  module FactSource
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      # Define a fact to be included in the hash by calling a method of the same name.
      #
      # If a block is included, it will be used to define a new method for the fact.
      #
      # @param [Symbol] fact_name The new fact's name
      def def_fact(fact_name, &block)
        add_fact_names(fact_name)
        define_method(fact_name, &block) if block
      end

      # Adds to the list of facts to be gathered.
      #
      # @param [Array<Symbol>] new_fact_names
      def add_fact_names(*new_fact_names)
        all_fact_names = fact_names + new_fact_names
        all_fact_names.uniq!
        all_fact_names.freeze
        class_variable_set(:@@_fact_names, all_fact_names)
      end

      # Names for all of the facts that will be returned by {FactSource#facts}.
      def fact_names
        class_variable_defined?(:@@_fact_names) ?
          class_variable_get(:@@_fact_names) :
          []
      end
    end

    # A hash mapping all of the fact names to values.
    def facts
      self.class.fact_names.map { |fact_name|
        fact_value = nil

        fact_known = catch(UNKNOWN_FACT) do
          fact_value = send(fact_name)
          true
        end

        fact_known ? [fact_name, fact_value] : nil
      }.compact.to_h
    end

    def unknown
      throw UNKNOWN_FACT
    end

    UNKNOWN_FACT = Object.new
  end
end
