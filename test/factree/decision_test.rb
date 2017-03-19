require 'test_helper'

describe Factree::Decision do
  subject do
    Factree::Decision.new do
      :decision
    end
  end

  it "has immutable instances" do
    subject.frozen?.must_equal true
  end

  it "uses the proc to decide on the next step" do
    subject.decide.must_equal :decision
  end
end
