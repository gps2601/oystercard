require 'journey'

class Oystercard
  MAXIMUM_BALANCE = 90
  MINIMUM_FARE = 1
  OVER_MAX_BALANCE_ERROR = 'Top up not allowed. Maximum balance exceeded.'
  BAL_UNDER_MIN_FARE = 'Touch in now allowed. Minimum balance not met.'
  attr_reader :balance, :entry_station, :journeys, :journey
  def initialize(balance, journeys = [], journey_class = Journey)
    @balance = balance
    @journeys = journeys
    @journey = nil
    @journey_class = journey_class
  end

  def top_up(amount)
    check_new_balance(amount)
    @balance += amount
  end

  def in_journey?
    !@journey.nil?
  end

  def touch_in(entry_station)
    check_card_has_minimum_fare

    add_journey_not_touched_out

    @journey = @journey_class.new

    @journey.start_journey(entry_station)
  end

  def touch_out(exit_station)
    @journey = @journey_class.new if @journey.nil?

    @journey.end_journey(exit_station)
    add_journey(@journey)
    deduct(@journey.fare)
    @journey = nil
  end

  private

  def add_journey_not_touched_out
    if !@journey.nil?
      add_journey(@journey)
      deduct(@journey.fare)
    end
  end

  def add_journey(journey)
    @journeys.push(journey)
  end

  def deduct(amount)
    @balance -= amount
  end

  def check_card_has_minimum_fare
    raise BAL_UNDER_MIN_FARE if @balance < MINIMUM_FARE
  end

  def check_new_balance(amount)
    raise OVER_MAX_BALANCE_ERROR if @balance + amount > MAXIMUM_BALANCE
  end
end
