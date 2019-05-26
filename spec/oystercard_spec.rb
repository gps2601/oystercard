require 'oystercard'

describe Oystercard do
  let(:my_oystercard) { Oystercard.new }
  it 'has a balance of 0 by default when initialized' do
    expect(my_oystercard.balance).to eq(0)
  end
end
