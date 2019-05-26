require 'oystercard'

describe Oystercard do
  let(:subject) { Oystercard.new(0, journeylog_double) }
  let(:entry_station_double) { double('entry_station_double') }
  let(:exit_station_double) { double('exit_station_double') }
  let(:journey_double) { double('journey_double') }
  let(:journey_class) { double('journey_class', new: journey_double) }
  let(:journeylog_double) { double('journeylog_double') }

  describe '#initialize' do
    it 'has a balance of 0 by default when initialized' do
      expect(subject.balance).to eq(0)
    end

    it 'has a journeylog object' do
      expect(subject.journeylog).to eq(journeylog_double)
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

  describe '#touch_in' do
    it 'will raise an error if card is touched in without minimum fare' do
      subject.top_up(Oystercard::MINIMUM_FARE - 1)

      expect { subject.touch_in(entry_station_double) }
        .to raise_error(Oystercard::BAL_UNDER_MIN_FARE)
    end

    it 'deduct a fare from journey if touch in and journey already ongoing' do
      subject = Oystercard.new(50, journeylog_double)
      allow(journeylog_double).to receive(:start_journey)
      allow(journeylog_double).to receive(:journey_in_progress?).and_return(true)

      allow(journeylog_double).to receive(:fare).and_return(6)

      subject.touch_in(entry_station_double)

      expect { subject.touch_in(exit_station_double) }
        .to change { subject.balance }.by(-6)
    end
  end

  describe '#touch_out' do
    it 'will reduce the balance by the minimum fare on touch out' do
      subject = Oystercard.new(Oystercard::MINIMUM_FARE, journeylog_double)
      allow(journeylog_double).to receive(:start_journey)
      allow(journeylog_double).to receive(:end_journey)
      allow(journeylog_double).to receive(:fare).and_return(Oystercard::MINIMUM_FARE)
      allow(journeylog_double).to receive(:complete)

      expect { subject.touch_out(exit_station_double) }
        .to change { subject.balance }.by(-Oystercard::MINIMUM_FARE)
    end
  end
end
