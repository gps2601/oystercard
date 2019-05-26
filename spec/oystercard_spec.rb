require 'oystercard'

describe Oystercard do
  let(:subject) { Oystercard.new(0) }
  describe '#initialize' do
    it 'has a balance of 0 by default when initialized' do
      expect(subject.balance).to eq(0)
    end
  end

  describe '#top_up' do
    it 'can increase the balance but the passed in amount' do
      starting_balance = subject.balance

      subject.top_up(5)

      expect(subject.balance).to eq(starting_balance + 5)
    end
  end
end
