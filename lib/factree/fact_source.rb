module Factree
  # Mixin to help define fact source classes.
  module FactSource
    UndefinedFactError = Class.new(StandardError)
    UnknownFactError = Class.new(StandardError)

    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      # Defines a named fact along with a method-like block used to compute the fact's value.
      #
      # @param [Symbol] fact_name The new fact's name
      def def_fact(fact_name, &block)
        all_fact_procs = fact_procs.merge(fact_name => block).freeze
        class_variable_set(:@@_fact_procs, all_fact_procs)
        fact_name
      end

      # @return [Array<Symbol>] Names for all of the defined facts, whether their values are known or not.
      def fact_names
        fact_procs.keys.freeze
      end

      # @api private
      def fact_procs
        class_variable_defined?(:@@_fact_procs) ?
          class_variable_get(:@@_fact_procs) :
          {}.freeze
      end

      # @return [Boolean] True if the fact has been defined (using {FactSource.def_fact})
      def defined?(fact_name)
        fact_procs.include? fact_name
      end
    end

    # Checks to see if the value of the fact is known.
    def known?(fact_name)
      fetch(fact_name) { return false }
      true
    end

    # Returns the value of the fact, or nil if the value is unknown
    def [](fact_name)
      fetch(fact_name) { nil }
    end

    # Returns the value of the fact.
    #
    # If the value is unknown, then the block will be called with the name of the fact. If no block is supplied, then an UnknownFactError will be raised.
    def fetch(fact_name, &block)
      ensure_defined fact_name
      fact_proc = self.class.fact_procs[fact_name]

      fact_value = nil
      fact_known = catch(UNKNOWN_FACT) do
        fact_value = instance_eval(&fact_proc)
        true
      end
      return fact_value if fact_known

      fetch_unknown(fact_name, &block)
    end

    # @api private
    def ensure_defined(fact_name)
      unless self.class.defined? fact_name
        raise UndefinedFactError, "undefined fact referenced: #{fact_name}"
      end
    end

    # @api private
    def fetch_unknown(fact_name)
      return yield(fact_name) if block_given?

      raise UnknownFactError, "unknown fact: #{fact_name}"
    end

    # A hash mapping all of the known fact names to values.
    def to_h
      self.class.fact_procs.flat_map { |fact_name, _fact_proc|
        fact_known = true
        fact_value = fetch(fact_name) { fact_known = false }

        fact_known ? [[fact_name, fact_value]] : []
      }.to_h
    end

    # Takes several FactSources and returns a single hash containing all of their facts mixed together.
    def self.to_combined_h(*sources)
      sources.map(&:to_h).inject({}, &:merge)
    end

    # Calling this method in a fact proc will signal that the fact's value is unknown.
    def unknown
      throw UNKNOWN_FACT
    end

    UNKNOWN_FACT = "Attempted to determine the value of a fact that is unknown"
  end
end
