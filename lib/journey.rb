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
    return calculate_fare_based_on_zone if entry && exit

    PENALTY_FARE
  end

  private

  def calculate_fare_based_on_zone
    difference = (entry.zone - exit.zone).abs
    difference + 1
  end
end
