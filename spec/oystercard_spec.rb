require 'oystercard'

describe Oystercard do
  let(:subject) { Oystercard.new(0) }
  let(:entry_station_double) { double('entry_station_double') }
  let(:exit_station_double) { double('exit_station_double') }
  let(:journey_double) { double('journey_double')}
  let(:journey_class) { double('journey_class', new: journey_double )}

  describe '#initialize' do
    it 'has a balance of 0 by default when initialized' do
      expect(subject.balance).to eq(0)
    end

    it 'has an journey instance variable that is nil' do
      expect(subject.journey).to eq(nil)
    end

    it 'has a journeys object' do
      expect(subject.journeys).to eq([])
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

    it 'will initialize a journey object' do
      subject = Oystercard.new(Oystercard::MINIMUM_FARE, [], journey_class)
      allow(journey_double).to receive(:start_journey)

      subject.touch_in(entry_station_double)

      expect(subject.journey).to eq(journey_double)
    end

    it 'will add a journey if touch in and journey already ongoing' do
      subject = Oystercard.new(Oystercard::MINIMUM_FARE, [], journey_class)
      allow(journey_double).to receive(:start_journey)
      allow(journey_double).to receive(:fare).and_return(1)

      subject.touch_in(entry_station_double)
      subject.touch_in(entry_station_double)

      expect(subject.journeys).to include(journey_double)
    end

    it 'deduct a fare from journey if touch in and journey already ongoing' do
      subject = Oystercard.new(Oystercard::MINIMUM_FARE, [], journey_class)
      allow(journey_double).to receive(:start_journey)
      allow(journey_double).to receive(:fare).and_return(6)

      subject.touch_in(entry_station_double)

      expect { subject.touch_in(exit_station_double) }
        .to change{subject.balance}.by(-6)
    end
  end

  describe '#touch_out' do
    it 'can change the state of in_journey from true to false' do
      subject = Oystercard.new(Oystercard::MINIMUM_FARE, [], journey_class)
      allow(journey_double).to receive(:start_journey)
      allow(journey_double).to receive(:end_journey)
      allow(journey_double).to receive(:fare).and_return(6)

      subject.touch_in(entry_station_double)
      subject.touch_out(exit_station_double)

      expect(subject.in_journey?).to eq(false)
    end

    it 'in_journey will remain false if touched out' do
      subject = Oystercard.new(Oystercard::MINIMUM_FARE, [], journey_class)
      allow(journey_double).to receive(:start_journey)
      allow(journey_double).to receive(:end_journey)
      allow(journey_double).to receive(:fare).and_return(6)

      subject.touch_out(exit_station_double)

      expect(subject.in_journey?).to eq(false)
    end

    it 'will reduce the balance by the minimum fare on touch out' do
      subject = Oystercard.new(Oystercard::MINIMUM_FARE, [], journey_class)
      allow(journey_double).to receive(:start_journey)
      allow(journey_double).to receive(:end_journey)
      allow(journey_double).to receive(:fare).and_return(Oystercard::MINIMUM_FARE)

      expect { subject.touch_out(exit_station_double) }
        .to change { subject.balance }.by(-Oystercard::MINIMUM_FARE)
    end

    it 'will set the journey to nil when touched out' do
      subject = Oystercard.new(Oystercard::MINIMUM_FARE, [], journey_class)
      allow(journey_double).to receive(:start_journey)
      allow(journey_double).to receive(:end_journey)
      allow(journey_double).to receive(:fare).and_return(Oystercard::MINIMUM_FARE)
      subject.touch_in(entry_station_double)
      subject.touch_out(exit_station_double)

      expect(subject.journey).to eq(nil)
    end

    it 'can accept a touch out station' do
      subject = Oystercard.new(Oystercard::MINIMUM_FARE)
      subject.touch_in(entry_station_double)

      expect(subject).to respond_to(:touch_out).with(1).argument
    end

    it 'can add a journey to journeys' do
      subject = Oystercard.new(Oystercard::MINIMUM_FARE, [], journey_class)
      allow(journey_double).to receive(:start_journey)
      allow(journey_double).to receive(:end_journey)
      allow(journey_double).to receive(:fare).and_return(6)
      subject.touch_in(entry_station_double)
      subject.touch_out(exit_station_double)

      expect(subject.journeys).to include(journey_double)
    end
  end
end
