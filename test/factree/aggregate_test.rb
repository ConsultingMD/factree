require 'test_helper'

describe Factree::Aggregate do
  describe "alternatives" do
    let(:nil_decision) do
      Factree::Decision.new([:fact_a]) { nil }
    end

    let(:final_decision) do
      Factree::Decision.new([:fact_b]) { conclusion }
    end

    let(:conclusion) { Factree::Conclusion.new(:b) }
    let(:facts) { {} }

    describe "with a nil decision followed by a final decision" do
      subject { Factree::Aggregate.alternatives(nil_decision, final_decision) }

      it "has the nil decision's required_facts" do
        subject.required_facts.must_equal nil_decision.required_facts
      end

      it "decides on conclusion in two steps" do
        subject.decide(facts).decide(facts).must_equal conclusion
      end
    end

    describe "with a final decision followed by a nil decision" do
      subject { Factree::Aggregate.alternatives(final_decision, nil_decision) }

      it "has the final decision's required_facts" do
        subject.required_facts.must_equal final_decision.required_facts
      end

      it "decides on conclusion in one step" do
        subject.decide(facts).must_equal conclusion
      end
    end

    describe "with only a nil decision" do
      subject { Factree::Aggregate.alternatives(nil_decision) }

      it "decides on nil in two steps" do
        # nil_decision decides nil, so we try the next decision, which is the nil decision at the end
        subject.decide(facts).decide(facts).must_be_nil
      end
    end

    describe "without any decisions" do
      subject { Factree::Aggregate.alternatives }

      it "returns a nil decision" do
        subject.decide(facts).must_be_nil
      end
    end
  end
end
