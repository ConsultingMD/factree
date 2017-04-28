require 'test_helper'

describe Factree::Aggregate do
  describe ".alternatives" do
    let(:facts) { :facts }
    let(:nil_decision) { -> (_) { nil } }
    let(:final_decision) { -> (_) { conclusion } }
    let(:conclusion) { Factree::Conclusion.new(:b) }
    let(:decisions) { [] }
    subject { Factree::Aggregate.alternatives(facts, *decisions) }

    describe "with a nil decision followed by a final decision" do
      let(:decisions) { [nil_decision, final_decision] }

      it "decides on conclusion" do
        assert_equal subject, conclusion
      end
    end

    describe "with a final decision followed by a nil decision" do
      let(:decisions) { [final_decision, nil_decision] }

      it "decides on conclusion" do
        assert_equal subject, conclusion
      end
    end

    describe "with only a nil decision" do
      let(:decisions) { [nil_decision] }

      it "decides on nil" do
        assert_nil subject
      end
    end

    it "returns a nil decision" do
      assert_nil subject
    end

    describe "with a mock decision" do
      let(:mock_decision) { Minitest::Mock.new }
      let(:decisions) { [mock_decision] }

      it "passes facts through to decision procs" do
        mock_decision.expect(:call, nil, [facts])
        subject
        mock_decision.verify
      end
    end
  end
end
