require 'station'

describe Station do
  let(:subject) { Station.new('Barbican', 1) }
  describe '#initialize' do
    it 'can create a station with a name' do
      expect(subject.name).to eq('Barbican')
    end

    it 'can create a station with a zone' do
      expect(subject.zone).to eq(1)
    end
  end
end
