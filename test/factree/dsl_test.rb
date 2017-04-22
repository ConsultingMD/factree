require 'test_helper'

describe Factree::DSL do
  let(:subject) { Module.new { extend Factree::DSL } }

  describe "#decision" do
    let(:required_facts) { [:fact_a, :fact_b] }
    let(:decide) { -> { :next } }
    let(:decision) { Factree::Decision.new(required_facts, &decide) }

    it "creates a Decision" do
      subject.decision(requires: required_facts, &decide).must_equal decision
    end

    describe "with a single required fact" do
      let(:required_fact) { :fact_a }
      let(:decision) { Factree::Decision.new([required_fact], &decide) }

      it "puts the fact into an array and creates a Decision with it" do
        subject.decision(requires: required_fact, &decide).must_equal decision
      end
    end
  end

  describe "#conclusion" do
    let(:conclusion_value) { :value }
    let(:conclusion) { Factree::Conclusion.new conclusion_value }

    it "creates a Conclusion" do
      subject.conclusion(conclusion_value).must_equal conclusion
    end
  end

  describe "#path" do
    let(:facts) { { sky_blue?: true } }
    let(:tree) do
      Factree::Decision.new([:sky_blue?]) do |facts|
        Factree::Conclusion.new :value
      end
    end
    let(:path) { Factree::Path.through_tree tree, facts }

    it "creates a Path through the tree" do
      subject.path(through: tree, given: facts).must_equal path
    end
  end

  describe "#decision_with_alternatives" do
    it "creates a decision from a list of alternatives" do
      subject.decision_with_alternatives().decide(nil).must_be_nil
    end
  end
end

