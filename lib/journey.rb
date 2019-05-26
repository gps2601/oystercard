class Journey
  MINIMUM_FARE = 1
  PENALTY_FARE = 6

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

  def fare
    return MINIMUM_FARE if entry && exit

    PENALTY_FARE
  end
end
