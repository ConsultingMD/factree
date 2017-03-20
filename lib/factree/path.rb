class Factree::Path
  def initialize(node_sequence)
    @nodes = node_sequence.to_a.freeze
    freeze
  end

  def complete?
    @nodes.last.conclusion?
  end

  def conclusion
    raise "Attempted to get conclusion from incomplete path" unless complete?

    @nodes.last.value
  end

  def required_facts
    [].concat(*@nodes.map(&:required_facts)).uniq
  end
end
