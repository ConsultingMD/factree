Factree::CycleError = Class.new(StandardError)

module Factree::Pathfinder
  # Returns the sequence of nodes for the furthest path possible from the given node with the given set of facts.
  def self.find_node_sequence(node, facts, visited=Set.new)
    # No cycles allowed
    if visited.include? node
      raise Factree::CycleError,
        "Cycle detected in decision tree. Node appeared twice: #{node}"
    end

    # Base case: leaf node (conclusion)
    return [node] if node.conclusion?

    # Base case: not enough facts to call node.decide
    missing_facts = node.required_facts - facts.keys
    return [node] unless missing_facts.empty?

    # Recursive case: return full path by prepending this node to the rest
    next_node = node.decide(facts)
    return [node] + find_node_sequence(next_node, facts, visited + [node])
  end
end
