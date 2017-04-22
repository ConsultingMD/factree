require 'factree/node'

# A Decision is a single node in a decision tree. It's responsible for choosing the next node based on the given set of facts.
class Factree::Decision < Factree::Node
  # The names of the facts required to make this decision
  # @return [Array<Symbol>]
  attr_reader :required_facts

  # Create a new decision tree node. The block is used to decide on the next node for a given set of facts when navigating through the tree.
  #
  # The block will be called with a hash containing all of the available facts. It must return another {Decision} (the next decision in the path through the tree) or a {Conclusion}.
  #
  # @param [Array<Symbol>] required_facts The names of facts required to decide on the next node.
  def initialize(required_facts=[], &decide)
    @decide = decide
    @required_facts = required_facts.uniq.freeze
    freeze
  end

  # Use the provided facts to decide on the next step.
  #
  # @return [Decision, Conclusion] The next node
  def decide(facts={})
    @decide.call(facts)
  end

  def to_s
    "<Factree::Decision decide=#{@decide} required_facts=[#{required_facts.join(", ")}]>"
  end

  def ==(other)
    other.is_a?(self.class) &&
      @required_facts == other.required_facts &&
      @decide == other.instance_variable_get(:@decide)
  end
end
