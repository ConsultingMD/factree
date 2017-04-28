require 'test_helper'

describe Factree::Facts do
  let(:params) do
    {
      with_a_fox?: true,
      location: :in_a_box
    }
  end
  subject { Factree::Facts.new(**params) }

  it "is a tasty frozen treat" do
    assert subject.frozen?
  end

  describe '#[]' do
    it "looks in the hash" do
      assert_equal :in_a_box, subject[:location]
    end

    it "throws MISSING_FACTS if facts are missing" do
      assert_throws(Factree::Facts::MISSING_FACTS) { subject[:bogus] }
    end
  end

  describe "#require" do
    it "throws when missing facts" do
      assert_nil(Factree::Facts.catch_missing_facts {
        subject.require(:in_a_house?, :with_a_fox?, :with_a_mouse?)
        :not_nil
      })
    end

    it "does nothing if the facts are all present" do
      subject.require :with_a_fox?
    end
  end

  describe ".catch_missing_facts" do
    it "executes the block if nothing's missing" do
      assert_equal :result, Factree::Facts.catch_missing_facts { :result }
    end

    it "returns nil if something's missing" do
      assert_nil Factree::Facts.catch_missing_facts { subject[:bogus] }
    end
  end

  describe "#to_h" do
    it "returns exactly what was passed to #new" do
      assert_equal params, subject.to_h
    end

    it "is a tasty frozen treat" do
      assert subject.to_h.frozen?
    end
  end

  describe ".coerce" do
    it "doesn't mess with a source that's already a Facts instance" do
      assert_same subject, Factree::Facts.coerce(subject)
    end

    it "converts a Hash to Facts" do
      assert_equal subject, Factree::Facts.coerce(params)
    end
  end

  describe "#==" do
    it "is true if the #to_h results are equal" do
      assert_equal subject, params
    end

    it "is false if #to_h results are not equal" do
      refute_equal({ foo: :bar }, subject)
    end
  end

  it "gets keys from the hash" do
    assert_equal params.keys, subject.keys
  end
end
