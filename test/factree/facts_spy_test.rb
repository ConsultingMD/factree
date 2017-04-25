require 'test_helper'
require 'factree/facts'
require 'factree/facts_spy'

describe Factree::FactsSpy do
  let(:params) { { foo: :bar } }
  let(:facts) { Factree::Facts.new(**params) }
  let(:listener) { Minitest::Mock.new }
  subject do
    Factree::FactsSpy.new facts do |*fact_names|
      listener.before_require(*fact_names)
    end
  end

  before do
    listener.expect(:before_require, nil, [:foo])
  end

  after do
    listener.verify
  end

  describe "#require" do
    it "notifies the listener" do
      subject.require(:foo)
    end
  end

  describe "#[]" do
    it "notifies the listener" do
      subject[:foo]
    end

    it "returns the fact value" do
      subject[:foo].must_equal :bar
    end
  end
end
