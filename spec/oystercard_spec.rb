require 'oystercard'

describe Oystercard do
  let(:subject) { Oystercard.new(0) }
  let(:entry_station_double) { double('entry_station_double') }
  describe '#initialize' do
    it 'has a balance of 0 by default when initialized' do
      expect(subject.balance).to eq(0)
    end

    it 'has an entry station instance variable that is nil' do
      expect(subject.entry_station).to eq(nil)
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

  describe '#in_journey?' do
    it 'can be initialized with a default value of false' do
      expect(subject.in_journey?).to eq(false)
    end
  end

  describe '#touch_in' do
    it 'can change the state of in_journey from false to true' do
      subject = Oystercard.new(Oystercard::MINIMUM_FARE)

      subject.touch_in(entry_station_double)

      expect(subject.in_journey?).to eq(true)
    end

    it 'in_journey will remain true if touched in' do
      subject = Oystercard.new(Oystercard::MINIMUM_FARE)

      subject.touch_in(entry_station_double)

      expect(subject.in_journey?).to eq(true)
    end

    it 'will raise an error if card is touched in without minimum fare' do
      subject.top_up(Oystercard::MINIMUM_FARE - 1)

      expect { subject.touch_in(entry_station_double) }
        .to raise_error(Oystercard::BAL_UNDER_MIN_FARE)
    end

    it 'will remember an entry station passed in' do
      subject = Oystercard.new(Oystercard::MINIMUM_FARE)

      subject.touch_in(entry_station_double)

      expect(subject.entry_station).to eq(entry_station_double)
    end
  end

  describe '#touch_out' do
    it 'can change the state of in_journey from true to false' do
      subject = Oystercard.new(Oystercard::MINIMUM_FARE)
      subject.touch_in(entry_station_double)
      subject.touch_out

      expect(subject.in_journey?).to eq(false)
    end

    it 'in_journey will remain false if touched out' do
      subject.touch_out

      expect(subject.in_journey?).to eq(false)
    end

    it 'will reduce the balance by the minimum fare on touch out' do
      expect { subject.touch_out }.to change { subject.balance }.by(-Oystercard::MINIMUM_FARE)
    end

    it 'will set the entry_station to nil when touched out' do
      subject = Oystercard.new(Oystercard::MINIMUM_FARE)
      subject.touch_in(entry_station_double)

      subject.touch_out

      expect(subject.entry_station).to eq(nil)
    end
  end
end
