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

  describe "#require" do
    it "notifies the listener" do
      listener.expect(:before_require, nil, [:foo])
      subject.require(:foo)
      listener.verify
    end
  end
end
