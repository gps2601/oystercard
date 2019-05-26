require 'oystercard'

describe Oystercard do
  let(:subject) { Oystercard.new(0) }
  describe '#initialize' do
    it 'has a balance of 0 by default when initialized' do
      expect(subject.balance).to eq(0)
    end
  end
end
