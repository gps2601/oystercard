class JourneyLog
  attr_reader :current_journey, :journeys
  def initialize(journey_class)
    @journey_class = journey_class
    @current_journey = nil
    @journeys = []
  end

  def start_journey(entry_station)
    @current_journey = @journey_class.new
    @current_journey.start_journey(entry_station)
  end

  def end_journey(exit_station)
    @current_journey.end_journey(exit_station)
    @journeys.push(@current_journey)
  end
end
