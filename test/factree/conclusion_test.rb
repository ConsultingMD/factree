require 'test_helper'

describe Factree::Conclusion do
  subject { Factree::Conclusion.new :value }

  it "has a value" do
    assert_equal :value, subject.value
  end

  it "is a tasty frozen treat" do
    assert subject.frozen?
  end
end

