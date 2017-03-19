class Factree::Decision
  def initialize(&decide)
    @decide = decide
    freeze
  end

  def decide
    @decide.call
  end
end
