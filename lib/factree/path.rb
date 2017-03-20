require 'factree/pathfinder'

# Paths follow a sequence of nodes from the root of a decision tree toward the leaves. Use {Path.through_tree} to find a path through a tree.
#
# A path may or may not actually reach a conclusion. If it does, it will be {complete?} and return the {conclusion} value. If it doesn't, then you can get the names of all of the facts needed to get past the next decision from {required_facts}.
class Factree::Path
  # Uses the given set of facts to find a path through the tree. The path will go as far as possible, and it will only stop when a conclusion is reached or when it doesn't have all the facts needed to make a decision.
  # @param [Factree::Decision, Factree::Conclusion] root The root node of the tree
  # @param [Hash] facts The set of facts used to make decisions
  # @return [Factree::Path]
  def self.through_tree(root, facts, finder: Factree::Pathfinder)
    new(finder.find_node_sequence(root, facts))
  end

  # Want to create a path? Use {.through_tree} instead.
  def initialize(node_sequence)
    @nodes = node_sequence.to_a.freeze
    freeze
  end

  # A path is {complete?} if it has reached a conclusion.
  def complete?
    @nodes.last.conclusion?
  end

  # Returns the conclusion value if this path is complete.
  def conclusion
    raise "Attempted to get conclusion from incomplete path" unless complete?

    @nodes.last.value
  end

  # A list of the facts required to make all of the decisions along the path, including the last one. If the path is not complete, then the facts in this list are sufficient to progress to the next node.
  # @return [Symbol] A list of fact names in the order they're required in the tree
  def required_facts
    [].concat(*@nodes.map(&:required_facts)).uniq
  end

  def ==(other_path)
    @nodes == other_path.instance_variable_get(:@nodes)
  end
end
