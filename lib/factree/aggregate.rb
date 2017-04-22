require 'factree/decision'

module Factree::Aggregate
  # Returns a new decision tree. The root of the tree calls the first Decision's decide function. If that returns nil, the next alternative is tried, and the next, and so on, until a valid Conclusion is returned.
  #
  # @param [Array<Decision>] decisions A decision followed by alternative decisions.
  # @return [Decision] A decision tree that checks the alternatives in order to reach a conclusion.
  def self.alternatives(*decisions)
    if decisions.empty?
      # Base case: no more decisions
      return Factree::Decision.new{ nil }
    else
      # Recursive case
      first, *rest = decisions
      remaining_alternatives = alternatives(*rest)

      return Factree::Decision.new first.required_facts do |facts|
        first_result = first.decide(facts)

        if first_result.nil?
          remaining_alternatives
        else
          first_result
        end
      end
    end
  end
end
