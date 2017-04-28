require 'test_helper'

describe Factree::Path do
  let(:required_facts) { %i[orbits_sun? sky_blue?] }
  let(:conclusion) { Factree::Conclusion.new :my_conclusion }
  subject { Factree::Path.new required_facts, conclusion }

  it "is complete" do
    assert subject.complete?
  end

  it "has a conclusion" do
    assert_equal :my_conclusion, subject.conclusion
  end

  it "has required facts" do
    assert_equal required_facts, subject.required_facts
  end

  describe "when the path doesn't end with a conclusion" do
    let(:conclusion) { nil }

    it "is incomplete" do
      refute subject.complete?
    end

    it "has no conclusion" do
      assert_raises(Factree::NoConclusionError) { subject.conclusion }
    end

    it "knows the facts needed to progress" do
      assert_equal %i[orbits_sun? sky_blue?], subject.required_facts
    end
  end

  describe "#==" do
    it "is not equal if the conclusion differs" do
      refute_equal Factree::Path.new(required_facts), subject
    end

    it "is not equal if the required_facts are different" do
      refute_equal Factree::Path.new([], conclusion), subject
    end

    it "is equal if the required_facts and conclusion are the same" do
      assert_equal Factree::Path.new(required_facts, conclusion), subject
    end
  end
end
