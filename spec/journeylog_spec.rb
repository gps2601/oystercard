require 'journeylog'

describe JourneyLog do
  let(:exit_station_double) { double('exit_station_double') }
  let(:entry_station_double) { double('entry_station_double') }
  let(:journey_double) { double('journey_double') }
  let(:journey_class) { double('journey_class', new: journey_double) }
  let(:subject) { JourneyLog.new(journey_class) }
  describe '#start_journey' do
    it 'can instantiate a journey object from class passed in' do
      allow(journey_double).to receive(:start_journey)

      subject.start_journey(entry_station_double)

      expect(subject.current_journey).to eq(journey_double)
    end

    it 'can give its journey a start station' do
      allow(journey_double).to receive(:start_journey)

      expect(journey_double).to receive(:start_journey).with(entry_station_double)

      subject.start_journey(entry_station_double)
    end

    it 'will finish a journey that is already in progress' do
      allow(journey_double).to receive(:start_journey)

      expect(journey_double).to receive(:start_journey).with(entry_station_double)

      subject.start_journey(entry_station_double)
      subject.start_journey(entry_station_double)

      expect(subject.journeys).to include(journey_double)
    end
  end

  describe '#end_journey' do
    it 'can tell a journey its finish station' do
      allow(journey_double).to receive(:end_journey)
      allow(journey_double).to receive(:start_journey)

      expect(journey_double).to receive(:end_journey).with(exit_station_double)

      subject.start_journey(entry_station_double)
      subject.end_journey(exit_station_double)
    end

    it 'can add a journey to journeys' do
      allow(journey_double).to receive(:end_journey)
      allow(journey_double).to receive(:start_journey)

      subject.start_journey(entry_station_double)
      subject.end_journey(exit_station_double)

      expect(subject.journeys).to include(journey_double)
    end
  end
end
