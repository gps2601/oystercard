class Journey
  attr_reader :entry, :exit
  def initialize
    @entry = nil
    @exit = nil
  end

  def start_journey(entry_station)
    @entry = entry_station
  end

  def end_journey(exit_station)
    @exit = exit_station
  end
end
