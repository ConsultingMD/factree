require 'factree/node'

class Factree::Conclusion < Factree::Node
  attr_reader :value

  def initialize(value)
    @value = value
    freeze
  end

  def conclusion?
    true
  end

  def to_s
    "<Factree::Conclusion value=#{@value.inspect}>"
  end

  def to_decision
    Factree::Decision.new { self }
  end

  def ==(other)
    other.is_a?(self.class) &&
      @value == other.instance_variable_get(:@value)
  end
end
