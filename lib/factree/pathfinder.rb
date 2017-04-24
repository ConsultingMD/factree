module Factree
  CycleError = Class.new(StandardError)
  InvalidDecisionError = Class.new(StandardError)

  # @api private
  module Pathfinder
    # Returns the sequence of nodes for the furthest path possible from the given node with the given set of facts.
    def self.find_node_sequence(node, raw_facts, visited=Set.new)
      facts = Factree::Facts.coerce(raw_facts)

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
      type_check_next_node(node, next_node)
      return [node] + find_node_sequence(next_node, facts, visited + [node])
    end

    private_class_method def self.type_check_next_node(source_node, next_node)
      unless next_node.is_a? Factree::Node
        raise Factree::InvalidDecisionError,
          "Expected #{source_node} to return a Factree::Node " +
          "from #decide. Got: #{next_node.inspect}"
      end
    end
  end
end
