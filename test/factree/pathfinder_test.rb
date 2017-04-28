require 'test_helper'

describe Factree::Pathfinder do
  describe "#find_node_sequence" do
    let(:facts) do
      {
        has_unibrow?: true,
        lives_in_trash_can?: false
      }
    end

    def root(facts)
      facts.require :lives_in_trash_can?

      if facts[:lives_in_trash_can?]
        Factree::Conclusion.new(:oscar)
      else
        unibrow_decision(facts)
      end
    end

    def unibrow_decision(facts)
      if facts[:has_unibrow?]
        Factree::Conclusion.new(:bert)
      else
        Factree::Conclusion.new(:ernie)
      end
    end

    let(:root_proc) { method :root }
    subject { Factree::Pathfinder.find facts, &root_proc }

    it "knows all of the facts that were required along the way" do
      assert_equal [:lives_in_trash_can?, :has_unibrow?], subject.required_facts
    end

    it "keeps going until it reaches a conclusion" do
      assert subject.complete?
    end

    describe "when there are not enough facts to reach a conclusion" do
      let(:facts) do
        { lives_in_trash_can?: false }
      end

      it "knows what facts are needed to make the next decision" do
        assert_includes subject.required_facts, :has_unibrow?
      end
    end

    describe "when a decision doesn't return a Node" do
      let(:root_proc) { -> (_) { nil } }

      it "raises an error" do
        -> { subject }.must_raise Factree::InvalidConclusionError
      end
    end
  end
end

