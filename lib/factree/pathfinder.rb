require 'factree/path'
require 'factree/facts'
require 'factree/facts_spy'

module Factree
  # Raised when a decision proc fails to return a Conclusion as expected
  InvalidConclusionError = Class.new(StandardError)

  # @api private
  module Pathfinder
    # @see DSL.find_path
    def self.find(raw_facts, &decide)
      facts_without_spy = Factree::Facts.coerce(raw_facts)
      required_facts = []
      facts = Factree::FactsSpy.new(facts_without_spy) do |*fact_names|
        required_facts += fact_names
      end

      conclusion = Factree::Facts.catch_missing_facts do
        conclusion = decide.call(facts)
        type_check_conclusion conclusion, &decide
        conclusion
      end

      Factree::Path.new(required_facts.uniq, conclusion)
    end

    private_class_method def self.type_check_conclusion(conclusion, &decide)
      unless conclusion.is_a? Factree::Conclusion
        raise Factree::InvalidConclusionError,
          "Expected #{decide.inspect} to return a Factree::Conclusion. " +
          "Got #{conclusion.inspect}"
      end
    end
  end
end
