require 'test_helper'

describe Factree::Decision do
  subject { Factree::Decision.new }

  it "has immutable instances" do
    subject.frozen?.must_be true
  end
end
