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

    it "throws MISSING_FACTS if facts are missing" do
      -> { subject[:bogus] }.must_throw Factree::Facts::MISSING_FACTS
    end

    it "includes fact names when it throws MISSING_FACTS" do
      catch(Factree::Facts::MISSING_FACTS) {
        subject[:bogus]
      }.must_equal [:bogus]
    end
  end

  describe ".catch_missing_facts" do
    it "returns empty missing_facts if nothing's missing" do
      _result, missing_facts = Factree::Facts.catch_missing_facts do
      end
      missing_facts.must_equal []
    end

    it "returns the block's value if nothing's missing" do
      result, _missing_facts = Factree::Facts.catch_missing_facts do
        :result
      end
      result.must_equal :result
    end

    it "returns a list of missing_facts if something's missing" do
      _result, missing_facts = Factree::Facts.catch_missing_facts do
        subject[:bogus]
      end
      missing_facts.must_equal [:bogus]
    end

    it "returns a nil result if something's missing" do
      result, _missing_facts = Factree::Facts.catch_missing_facts do
        subject[:bogus]
        :ignored_result
      end
      result.must_be_nil
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

  it "gets keys from the hash" do
    subject.keys.must_equal params.keys
  end
end
