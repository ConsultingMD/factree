require 'factree/pathfinder'

class Factree::Path
  def self.through(root, facts, finder: Factree::Pathfinder)
    new(finder.find_node_sequence(root, facts))
  end

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

  def ==(other_path)
    @nodes == other_path.instance_variable_get(:@nodes)
  end
end
