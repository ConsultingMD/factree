require 'factree/node'

# A Decision is a single node in a decision tree. It's responsible for choosing the next node based on the given set of facts.
class Factree::Decision < Factree::Node
  # The names of the facts explicitly required to make the decision
  #
  # @return [Array<Symbol>]
  attr_reader :required_facts

  # @see DSL.decision
  # @param [Array<Symbol>] required_facts
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

  def to_decision
    self
  end

  def ==(other)
    other.is_a?(self.class) &&
      @required_facts == other.required_facts &&
      @decide == other.instance_variable_get(:@decide)
  end
end
