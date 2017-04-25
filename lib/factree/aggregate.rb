module Factree::Aggregate
  # @see DSL.decide_between_alternatives
  def self.alternatives(facts, *decide_procs)
    conclusion = nil
    decide_procs.each do |decide|
      conclusion = decide.call(facts)
      break unless conclusion.nil?
    end
    conclusion
  end
end
