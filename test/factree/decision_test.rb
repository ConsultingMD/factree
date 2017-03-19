require 'test_helper'

describe Factree::Decision do
  let(:required_facts) { %i[fact_b fact_a] }
  let(:decision) { :decision }
  subject do
    Factree::Decision.new(required_facts) do
      decision
    end
  end

  it "has immutable instances" do
    subject.frozen?.must_equal true
  end

  it "uses the proc to decide on the next step" do
    subject.decide.must_equal decision
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
end
