require 'test_helper'

describe Factree::FactSource do
  let(:source_class) do
    Class.new do
      include Factree::FactSource

      def_fact(:is_hungry?) { true }
      def_fact(:color) { :brown }
    end
  end
  subject { source_class.new }

  describe ".fact" do
    it "defines methods for facts" do
      subject.color.must_equal :brown
    end
  end

  describe ".fact_names" do
    it "lists all the defined fact names" do
      subject.class.fact_names.must_equal [:is_hungry?, :color]
    end

    it "is a tasty frozen treat" do
      subject.class.fact_names.must_be :frozen?
    end
  end

  describe "#facts" do
    it "returns a hash with all of the fact values" do
      subject.facts.must_equal(
        is_hungry?: true,
        color: :brown
      )
    end
  end
end
