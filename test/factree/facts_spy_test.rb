require 'test_helper'

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
      assert_equal :bar, subject[:foo]
    end
  end
end
