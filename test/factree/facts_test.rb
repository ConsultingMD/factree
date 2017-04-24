require 'test_helper'
require 'factree/facts'

describe Factree::Facts do
  let(:params) do
    {
      with_a_fox?: true,
      location: :in_a_box
    }
  end
  subject { Factree::Facts.new(**params) }

  it "is a tasty frozen treat" do
    subject.must_be :frozen?
  end

  describe '#[]' do
    it "looks in the hash" do
      subject[:with_a_fox?].must_equal true
    end
  end

  describe "#to_h" do
    it "returns exactly what was passed to #new" do
      subject.to_h.must_equal params
    end

    it "is a tasty frozen treat" do
      subject.to_h.must_be :frozen?
    end
  end

  describe ".coerce" do
    it "doesn't mess with a source that's already a Facts instance" do
      Factree::Facts.coerce(subject).must_be_same_as subject
    end

    it "converts a Hash to Facts" do
      Factree::Facts.coerce(params).must_equal subject
    end
  end

  describe "#==" do
    it "is true if the #to_h results are equal" do
      subject.must_equal params
    end

    it "is false if #to_h results are not equal" do
      subject.wont_equal(foo: :bar)
    end
  end
end
