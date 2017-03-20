require 'test_helper'
require 'factree/pathfinder'

describe Factree::Pathfinder do
  describe "#find_path" do
    let(:facts) do
      {
        has_unibrow?: true,
        lives_in_trash_can?: false
      }
    end

    let(:root) do
      Factree::Decision.new([:lives_in_trash_can?]) do |facts|
        if facts[:lives_in_trash_can?]
          Factree::Conclusion.new(:oscar)
        else
          unibrow_decision
        end
      end
    end

    let(:unibrow_decision) do
      Factree::Decision.new([:has_unibrow?]) do |facts|
        if facts[:has_unibrow?]
          Factree::Conclusion.new(:bert)
        else
          Factree::Conclusion.new(:ernie)
        end
      end
    end

    subject { Factree::Pathfinder.find_path root, facts }

    it "starts at the root" do
      subject.first.must_equal root
    end

    it "keeps going until it reaches a conclusion" do
      subject.last.conclusion?.must_equal true
    end

    describe "when there are not enough facts to reach a conclusion" do
      let(:facts) do
        { lives_in_trash_can?: false }
      end

      it "stops when it encounters the decision that needs more facts" do
        subject.last.must_equal unibrow_decision
      end
    end

    describe "with a cycle in the tree" do
      let(:root) do
        decision = Factree::Decision.new() do |facts|
          decision
        end
      end

      it "raises an error" do
        -> { subject }.must_raise Factree::CycleError
      end
    end
  end
end

