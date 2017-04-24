require 'forwardable'

class Factree::Facts
  extend Forwardable
  def_delegators :@hash,
    :[],
    :to_h,
    :to_hash,
    :keys

  def self.coerce(source)
    return source if source.is_a? self
    new(**source)
  end

  def initialize(**hash)
    @hash = hash.freeze
    freeze
  end

  def ==(other)
    self.to_h == other.to_h
  end
end
