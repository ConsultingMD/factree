require 'delegate'

# {Facts} decorator to spy on calls to {Facts#require}
class Factree::FactsSpy < SimpleDelegator
  def initialize(facts, &before_require)
    @facts = facts
    @before_require = before_require
    super(facts)
    freeze
  end

  def require(*fact_names)
    @before_require.call(*fact_names)
    super
  end
end
