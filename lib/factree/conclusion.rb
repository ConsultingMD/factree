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
end
