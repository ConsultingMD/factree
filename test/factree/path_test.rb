require 'test_helper'

describe Factree::Path do
  let(:complete_node_sequence) do
    [
      Factree::Decision.new([:orbits_sun?, :sky_blue?]) { |f| },
      Factree::Decision.new([:grass_green?, :sky_blue?]) { |f| },
      Factree::Conclusion.new(:earth)
    ]
  end
  let(:node_sequence) { complete_node_sequence }
  subject { Factree::Path.new node_sequence }

  it "is complete" do
    subject.complete?.must_equal true
  end

  it "has a conclusion" do
    subject.conclusion.must_equal :earth
  end

  it "knows the facts required by the entire sequence in order" do
    subject.required_facts.must_equal %i[orbits_sun? sky_blue? grass_green?]
  end

  describe "when the path doesn't end with a conclusion" do
    let(:node_sequence) { complete_node_sequence.take 1 }

    it "is incomplete" do
      subject.complete?.must_equal false
    end

    it "has no conclusion" do
      -> { subject.conclusion }.must_raise StandardError
    end

    it "knows the facts needed to progress" do
      subject.required_facts.must_equal %i[orbits_sun? sky_blue?]
    end
  end

  describe ".through_tree" do
    it "has a convenient interface to use Pathfinder" do
      finder = Minitest::Mock.new
      root = :root
      facts = :facts
      finder.expect(:find_node_sequence, complete_node_sequence, [root, facts])
      Factree::Path.through_tree(root, facts, finder: finder).must_equal subject
      finder.verify
    end
  end
end
