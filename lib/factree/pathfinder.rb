require 'factree/path'

module Factree
  # Raised when a decision proc fails to return a Conclusion as expected
  InvalidConclusionError = Class.new(StandardError)

  module Pathfinder
    # @see DSL.find_path
    def self.find(raw_facts, &decide)
      facts = Factree::Facts.coerce(raw_facts)

      conclusion = nil
      missing_facts = Factree::Facts.catch_missing_facts do
        conclusion = decide.call(facts)
        type_check_conclusion conclusion, &decide
      end

      Factree::Path.new(missing_facts, conclusion)
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
