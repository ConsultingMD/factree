require 'test_helper'

describe Factree::Decision do
  let(:required_facts) { %i[fact_b fact_a] }
  let(:decide) { Minitest::Mock.new }
  subject do
    Factree::Decision.new(required_facts) do |*args|
      decide.call(*args)
    end
  end

  it "has immutable instances" do
    subject.frozen?.must_equal true
  end

  describe "#decide" do
    let(:facts) { :facts }
    let(:decision) { Factree::Node.new }

    before do
      decide.expect(:call, decision, [facts])
    end

    it "uses the supplied proc to decide on the next step" do
      subject.decide(facts).must_equal decision
      decide.verify
    end
  end

  it "has immutable required_facts" do
    subject.required_facts.frozen?.must_equal true
  end

  it "preserves the order of required_facts" do
    subject.required_facts.must_equal required_facts
  end

  describe "with duplicate required_facts" do
    let(:required_facts) { %i[fact_b fact_c fact_a fact_b] }

    it "dedups required_facts" do
      subject.required_facts.must_equal %i[fact_b fact_c fact_a]
    end
  end

  describe "#to_s" do
    it "prints out a useful representation for debugging" do
      subject.to_s.must_be :=~, /<Factree::Decision decide=.*decision_test\.rb:\d+> required_facts=\[fact_b, fact_a\]>/
    end
  end

  describe "#to_decision" do
    it "returns itself" do
      subject.to_decision.must_equal subject
    end
  end

  it "is not a conclusion" do
    subject.conclusion?.must_equal false
  end
end
