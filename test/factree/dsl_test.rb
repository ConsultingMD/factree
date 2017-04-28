require 'test_helper'

describe Factree::DSL do
  let(:subject) { Module.new { extend Factree::DSL } }

  describe "#conclusion" do
    let(:conclusion_value) { :value }
    let(:conclusion) { Factree::Conclusion.new conclusion_value }

    it "creates a Conclusion" do
      assert_equal conclusion, subject.conclusion(conclusion_value)
    end
  end

  describe "#find_path" do
    let(:facts) { { sky_blue?: true } }
    let(:decide) do
      -> (facts) {
        facts.require :sky_blue?
        Factree::Conclusion.new :value
      }
    end
    let(:path) { Factree::Pathfinder.find(**facts, &decide) }

    it "creates a Path through the tree" do
      assert_equal path, subject.find_path(**facts, &decide)
    end
  end

  describe "#decide_between_alternatives" do
    it "creates a decision proc from a list of alternatives" do
      assert_nil subject.decide_between_alternatives({})
    end
  end
end

