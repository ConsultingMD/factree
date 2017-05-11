require 'test_helper'

describe Factree::FactSource do
  let(:source_class) do
    Class.new do
      include Factree::FactSource

      def_fact(:is_hungry?) { true }
      def_fact(:color) { :brown }
      def_fact(:texture) { unknown }
    end
  end
  subject { source_class.new }

  describe ".defined?" do
    it "is true when a fact has been defined for the class" do
      assert source_class.defined?(:color)
    end

    it "is false when a fact has not been defined for the class" do
      refute source_class.defined?(:height)
    end
  end

  describe ".fact_names" do
    it "lists all the defined fact names" do
      assert_equal [:is_hungry?, :color, :texture], subject.class.fact_names
    end

    it "is a tasty frozen treat" do
      assert subject.class.fact_names.frozen?
    end
  end

  describe "#known?" do
    it "is true when the value of a fact is known" do
      assert subject.known?(:color)
    end

    it "is false when the value of a fact is unknown" do
      refute subject.known?(:texture)
    end
  end

  describe "#[]" do
    it "returns a known fact's value" do
      assert_equal :brown, subject[:color]
    end

    it "returns nil for an unknown fact" do
      assert_nil subject[:texture]
    end
  end

  describe "#fetch" do
    it "returns a known fact's value" do
      assert_equal :brown, subject.fetch(:color)
    end

    it "raises an error if a fact is unknown and no block is supplied" do
      assert_raises Factree::FactSource::UnknownFactError do
        subject.fetch(:texture)
      end
    end

    it "calls the block with the fact name if the fact is unknown" do
      called = false
      subject.fetch(:texture) { called = true }
      assert called
    end

    it "does not deal with undefined facts" do
      assert_raises Factree::FactSource::UndefinedFactError do
        subject.fetch(:bogus)
      end
    end
  end

  describe "#to_h" do
    it "returns a hash with all of the known fact values" do
      assert_equal({
        is_hungry?: true,
        color: :brown
      }, subject.to_h)
    end
  end

  describe ".to_combined_h" do
    let(:sources) {
      [
        # Pretend these hashes are FactSources. Both types support to_h.
        { a: 1 },
        { b: 2 }
      ]
    }
    subject { Factree::FactSource.to_combined_h *sources }

    it "combines the facts from several sources into a single hash" do
      assert_equal({ a: 1, b: 2 }, subject)
    end

    describe "when later fact names conflict with earlier ones" do
      let(:sources) {
        [
          # Pretend these hashes are FactSources. Both types support to_h.
          { a: 1 },
          { a: 2 }
        ]
      }

      it "uses the later value" do
        assert_equal({ a: 2 }, subject)
      end
    end
  end
end
