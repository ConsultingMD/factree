class Factree::Decision
  attr_reader :required_facts

  def initialize(required_facts=[], &decide)
    @decide = decide
    @required_facts = required_facts.uniq.freeze
    freeze
  end

  def decide
    @decide.call
  end
end
