# This is the base class for nodes in a decision tree.
#
# I'm torn on whether this should exist or not. Duck typing may be sufficient on its own.
class Factree::Node
  def conclusion?
    false
  end

  def required_facts
    []
  end
end
