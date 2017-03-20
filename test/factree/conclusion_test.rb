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
end

