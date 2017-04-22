require 'factree/decision'
require 'factree/conclusion'
require 'factree/path'
require 'factree/aggregate'

# Readable shortcuts to common functions
module Factree::DSL
  def decision(requires: [], &decide)
    required_facts = [requires].flatten
    Factree::Decision.new(required_facts, &decide)
  end

  def conclusion(value)
    Factree::Conclusion.new(value)
  end

  def path(through:, given: {})
    Factree::Path.through_tree(through, given)
  end

  def decision_with_alternatives(*decisions)
    Factree::Aggregate.alternatives(*decisions)
  end
end
