require 'test_helper'

describe Factree::Conclusion do
  subject { Factree::Conclusion.new :value }

  it "has a value" do
    subject.value.must_equal :value
  end

  it "is a conclusion" do
    subject.conclusion?.must_equal true
  end
end

