# A Decision is a single node in a decision tree. It's responsible for choosing the next node based on the given set of facts.
class Factree::Decision
  # The names of the facts required to make this decision
  # @return [Array<Symbol>]
  attr_reader :required_facts

  def initialize(required_facts=[], &decide)
    @decide = decide
    @required_facts = required_facts.uniq.freeze
    freeze
  end

  # Use the provided facts to decide on the next step.
  # @return [Decision, Conclusion] The next node
  def decide(facts)
    @decide.call(facts)
  end
end
