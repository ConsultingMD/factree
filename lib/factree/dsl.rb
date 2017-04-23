require 'factree/decision'
require 'factree/conclusion'
require 'factree/path'
require 'factree/aggregate'

# Readable shortcuts to common functions.
module Factree::DSL
  # Creates a {Decision} -- a non-leaf node in a decision tree.
  #
  # The block is used to decide on the next node for a given set of facts when navigating through the tree. It will be called with a hash containing all of the available facts. It should return another {Decision} (the next decision in the path through the tree) or a {Conclusion}.
  #
  # @param [Symbol, Array<Symbol>] requires Names of facts explicitly required to make the decision.
  # @return [Decision]
  def decision(requires: [], &decide)
    required_facts = [requires].flatten
    Factree::Decision.new(required_facts, &decide)
  end

  # Creates a {Conclusion} -- a leaf in a decision tree.
  #
  # The conclusion has an associated value (can be anything.)
  #
  # @param [Object] value Any value, including nil
  # @return [Decision]
  def conclusion(value=nil)
    Factree::Conclusion.new(value)
  end

  # Navigates as far as possible through a decision tree with the given set of facts.
  #
  # The path will stop when either
  # - a conclusion is reached, or
  # - there aren't enough facts to make a decision.
  #
  # == Pathfinding
  #
  # We start with the root node. If it's a conclusion, then that's it -- we're done.
  #
  # If it's a decision, then we examine its {Decision#required_facts required_facts}. If one of them is missing from the given set of facts, then the path stops there.
  #
  # If all of the required facts are present, then the facts (all of them, not just the explicitly required ones) are passed to its {Decision#decide decide} method. That should return the next node in the sequence.
  #
  # == Errors
  #
  # If a decision function fails to return a {Node}, an {InvalidDecisionError} will be raised.
  #
  # If a node is visited more than once, a {CycleError} will be raised.
  #
  # @param [Node] through The root node of the tree
  # @param [Hash] given The set of facts used to make decisions
  # @return [Path] The path followed through the tree
  def path(through:, given: {})
    Factree::Path.through_tree(through, given)
  end

  # A tool for composing lists of {Decisions}s to be tried one after another until a conclusion is reached. When a decision returns nil instead of a {Node}, the next node in {decisions} is used instead.
  #
  # If the last decision is reached and it returns nil as well, then the whole decision tree returns nil.
  #
  # @param [Array<#to_decision>] nodes A decision followed by alternative decisions. (Conclusions can be used as well.)
  # @return [Decision] A decision tree that checks the alternatives in order to reach a conclusion.
  def decision_with_alternatives(*decisions)
    Factree::Aggregate.alternatives(*decisions)
  end
end
