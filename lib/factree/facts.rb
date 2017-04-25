require 'forwardable'

class Factree::Facts
  extend Forwardable
  def_delegators :@hash,
    :[],
    :to_h,
    :keys

  def self.coerce(source)
    return source if source.is_a? self
    new(**source)
  end

  def initialize(**hash)
    @hash = hash.freeze
    freeze
  end

  def known?(fact_name)
    @hash.has_key? fact_name
  end

  def require(*fact_names)
    self.class.throw_missing_facts unless fact_names.all? { |name| known? name }
  end

  def [](fact_name)
    self.require(fact_name)
    @hash[fact_name]
  end

  def ==(other)
    self.to_h == other.to_h
  end

  def self.throw_missing_facts
    throw MISSING_FACTS
  end

  def self.catch_missing_facts
    catch(MISSING_FACTS) do
      yield
    end
  end

  # Kernel#catch uses object ID to match thrown values. This gives us a unique
  # ID and a readable message in case it's thrown somewhere it's not expected.
  MISSING_FACTS = "Attempted to read missing facts from a Factree::Facts instance"
end
