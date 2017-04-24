class Factree::Facts
  def self.coerce(source)
    return source if source.is_a? self
    new(**source)
  end

  def initialize(**hash)
    @hash = hash.freeze
    freeze
  end

  def [](fact_name)
    @hash[fact_name]
  end

  def ==(other)
    self.to_h == other.to_h
  end

  def to_h
    @hash
  end

  alias to_hash to_h
end
