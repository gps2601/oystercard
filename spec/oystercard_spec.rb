require 'oystercard'

describe Oystercard do
  let(:subject) { Oystercard.new(0) }
  describe '#initialize' do
    it 'has a balance of 0 by default when initialized' do
      expect(subject.balance).to eq(0)
    end
  end

  describe '#top_up' do
    it 'can increase the balance by the passed in amount' do
      expect { subject.top_up(5) }.to change { subject.balance }.by(5)
    end

    it 'will raise an error if new balance will exceed the maximum' do
      expect { subject.top_up(Oystercard::MAXIMUM_BALANCE + 1) }
        .to raise_error(Oystercard::OVER_MAX_BALANCE_ERROR)
    end
  end

  describe '#deduct' do
    it 'can deduct a specified amount from the card' do
      subject.top_up(50)

      expect { subject.deduct(5) }.to change { subject.balance }.by(-5)
    end
  end

  describe '#in_journey?' do
    it 'can be initialized with a default value of false' do
      expect(subject.in_journey?).to eq(false)
    end

    it 'can be initialized with a value of true' do
      subject = Oystercard.new(0, true)

      expect(subject.in_journey?).to eq(true)
    end
  end

  describe '#touch_in' do
    it 'can change the state of in_journey from false to true' do
      subject.touch_in

      expect(subject.in_journey?).to eq(true)
    end

    it 'in_journey will remain true if touched in' do
      subject = Oystercard.new(0, true)

      subject.touch_in

      expect(subject.in_journey?).to eq(true)
    end
  end

  describe '#touch_out' do
    it 'can change the state of in_journey from true to false' do
      subject = Oystercard.new(0, true)

      subject.touch_out

      expect(subject.in_journey?).to eq(false)
    end

    it 'in_journey will remain false if touched out' do
      subject.touch_out

      expect(subject.in_journey?).to eq(false)
    end
  end
end
