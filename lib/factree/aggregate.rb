require 'factree/decision'

module Factree::Aggregate
  # @see DSL.decision_with_alternatives
  def self.alternatives(*decisions)
    if decisions.empty?
      # Base case: no more decisions
      return Factree::Decision.new{ nil }
    else
      # Recursive case
      first, *rest = decisions
      first_decision = first.to_decision
      remaining_alternatives = alternatives(*rest)

      return Factree::Decision.new first_decision.required_facts do |facts|
        first_result = first_decision.decide(facts)

        if first_result.nil?
          remaining_alternatives
        else
          first_result
        end
      end
    end
  end
end
