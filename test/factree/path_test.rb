require 'test_helper'

describe Factree::Path do
  let(:required_facts) { %i[orbits_sun? sky_blue?] }
  let(:conclusion) { Factree::Conclusion.new :my_conclusion }
  subject { Factree::Path.new required_facts, conclusion }

  it "is complete" do
    subject.complete?.must_equal true
  end

  it "has a conclusion" do
    subject.conclusion.must_equal :my_conclusion
  end

  it "has required facts" do
    subject.required_facts.must_equal required_facts
  end

  describe "when the path doesn't end with a conclusion" do
    let(:conclusion) { nil }

    it "is incomplete" do
      subject.complete?.must_equal false
    end

    it "has no conclusion" do
      -> { subject.conclusion }.must_raise Factree::NoConclusionError
    end

    it "knows the facts needed to progress" do
      subject.required_facts.must_equal %i[orbits_sun? sky_blue?]
    end
  end

  describe "#==" do
    it "is not equal if the conclusion differs" do
      subject.wont_equal Factree::Path.new(required_facts)
    end

    it "is not equal if the required_facts are different" do
      subject.wont_equal Factree::Path.new([], conclusion)
    end

    it "is equal if the required_facts and conclusion are the same" do
      subject.must_equal Factree::Path.new(required_facts, conclusion)
    end
  end
end
