class Factree::Conclusion
  attr_reader :value

  def initialize(value)
    @value = value
    freeze
  end

  def ==(other)
    self.class == other.class &&
      @value == other.instance_variable_get(:@value)
  end
end
