module Factree
  # Raised when attempting to get a conclusion from an incomplete path
  NoConclusionError = Class.new(StandardError)

  # {Path}s record useful information about an attempt to reach a {Conclusion} for a decision proc.
  #
  # A path may or may not actually reach a conclusion. If it does, it will be {complete?} and return the {conclusion} value. If it doesn't, then you can get the names of all of the facts needed to get past the next decision step from {required_facts}.
  class Path
    # Want to create a path? Use {DSL.find_path} instead.
    #
    # @api private
    def initialize(required_facts=[], conclusion=nil)
      @required_facts = required_facts.to_a.uniq
      @conclusion = conclusion
      freeze
    end

    # A path is {complete?} if it has reached a conclusion.
    def complete?
      !@conclusion.nil?
    end

    # Returns the conclusion value if this path is complete.
    def conclusion
      # We don't want to return nil to indicate a missing conclusion, since that could confused for a nil conclusion with a nil value.
      raise Factree::NoConclusionError, "Attempted to get conclusion from incomplete path" unless complete?

      @conclusion.value
    end

    # A list of the facts that were required to get this far, plus any facts needed to make further progress. If the path is not complete, then the facts in this list are sufficient to progress past this point.
    #
    # @return [Array<Symbol>] A list of fact names in the order they're required in the tree
    attr_reader :required_facts

    def ==(other)
      self.class == other.class &&
        @required_facts == other.instance_variable_get(:@required_facts) &&
        @conclusion == other.instance_variable_get(:@conclusion)
    end
  end
end
