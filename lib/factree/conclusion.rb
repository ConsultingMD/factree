class Factree::Conclusion
  attr_reader :value

  def initialize(value)
    @value = value
    freeze
  end

  def conclusion?
    true
  end
end
