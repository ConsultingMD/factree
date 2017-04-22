require 'test_helper'

describe Factree::Conclusion do
  subject { Factree::Conclusion.new :value }

  it "has a value" do
    subject.value.must_equal :value
  end

  it "is a conclusion" do
    subject.conclusion?.must_equal true
  end

  it "has no fact dependencies" do
    subject.required_facts.must_equal []
  end

  describe "#to_s" do
    it "prints out a useful representation for debugging" do
      subject.to_s.must_be :=~, /<Factree::Conclusion value=:value>/
    end
  end

  describe "#to_decision" do
    let(:decision) { subject.to_decision }

    it "wraps itself in a decision" do
      decision.decide.must_equal subject
    end

    it "doesn't pass on its required_facts" do
      decision.required_facts.must_be_empty
    end
  end
end

