require 'test_helper'

describe Factree::DSL do
  let(:subject) { Module.new { extend Factree::DSL } }

  describe "#conclusion" do
    let(:conclusion_value) { :value }
    let(:conclusion) { Factree::Conclusion.new conclusion_value }

    it "creates a Conclusion" do
      subject.conclusion(conclusion_value).must_equal conclusion
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
      subject.find_path(**facts, &decide).must_equal path
    end
  end

  describe "#decide_between_alternatives" do
    it "creates a decision proc from a list of alternatives" do
      subject.decide_between_alternatives({}).must_be_nil
    end
  end
end

