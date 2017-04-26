require 'factree/conclusion'
require 'factree/pathfinder'
require 'factree/aggregate'

# Readable shortcuts to common functions.
module Factree::DSL
  # Creates a {Conclusion} to return from a decision proc.
  #
  # The conclusion has an associated value (can be anything.)
  #
  # @param [Object] value Any value, including nil
  # @return [Conclusion]
  def conclusion(value=nil)
    Factree::Conclusion.new(value)
  end

  # Navigates as far as possible through a decision tree with the given set of facts.
  #
  # The path will stop when either
  # - a conclusion is returned, or
  # - there aren't enough facts to make the decision.
  #
  # == Errors
  #
  # If a decision function fails to return a {Conclusion}, an {InvalidConclusionError} will be raised.
  #
  # @param [Hash] facts The set of facts used to make decisions
  # @param [Proc] decide The decision proc. Takes a set of {Facts} and returns a {Conclusion}.
  # @return [Path] Information about the path followed through the tree
  def find_path(**facts, &decide)
    Factree::Pathfinder.find(facts, &decide)
  end

  # A tool for composing lists of decision procs to be tried one after another until a conclusion is reached. When a proc returns nil instead of a {Conclusion}, the next proc in decide_procs is used instead.
  #
  # If the last decision proc is reached and it returns nil, then this method returns nil.
  #
  # @param [Facts] facts The facts to pass through to the decision procs.
  # @param [Array<#call>] decide_procs A decision proc followed by alternative procs.
  # @return [Decision] A decision tree that checks the alternatives in order to reach a conclusion.
  def decide_between_alternatives(facts, *decide_procs)
    Factree::Aggregate.alternatives(facts, *decide_procs)
  end
end
