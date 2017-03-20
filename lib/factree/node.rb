# This is the base class for nodes in a decision tree.
class Factree::Node
  def conclusion?
    false
  end

  def required_facts
    []
  end
end
