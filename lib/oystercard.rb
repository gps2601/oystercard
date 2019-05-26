class Oystercard
  MAXIMUM_BALANCE = 90
  MINIMUM_FARE = 1
  OVER_MAX_BALANCE_ERROR = 'Top up not allowed. Maximum balance exceeded.'
  BAL_UNDER_MIN_FARE = 'Touch in now allowed. Minimum balance not met.'
  attr_reader :balance, :entry_station, :journeylog
  def initialize(balance, journeylog)
    @balance = balance
    @journeylog = journeylog
  end

  def top_up(amount)
    check_new_balance(amount)
    @balance += amount
  end

  def touch_in(entry_station)
    check_card_has_minimum_fare

    deduct_incomplete_journeys

    @journeylog.start_journey(entry_station)
  end

  def touch_out(exit_station)
    @journeylog.end_journey(exit_station)
    deduct(@journeylog.fare)
    @journeylog.complete
  end

  private

  def deduct_incomplete_journeys
    deduct(@journeylog.fare) if @journeylog.journey_in_progress?
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
