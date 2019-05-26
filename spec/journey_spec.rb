require 'journey'

describe Journey do
  let(:subject) { Journey.new }
  let(:entry_station) {double('entry_station')}
  let(:exit_station) {double('exit_station')}

  describe '#start_journey' do
    it 'can start a journey' do
      expect(subject).to respond_to(:start_journey)
    end

    it 'can set an entry_station' do
      subject.start_journey(entry_station)

      expect(subject.entry).to eq(entry_station)
    end
  end

  describe '#end_journey' do
    it 'can end a journey' do
      expect(subject).to respond_to(:end_journey)
    end

    it 'can set an entry_station' do
      subject.end_journey(exit_station)

      expect(subject.exit).to eq(exit_station)
    end
  end
end
