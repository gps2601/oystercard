class Oystercard
  MAXIMUM_BALANCE = 90
  MINIMUM_FARE = 1
  OVER_MAX_BALANCE_ERROR = 'Top up not allowed. Maximum balance exceeded.'
  BAL_UNDER_MIN_FARE = 'Touch in now allowed. Minimum balance not met.'
  attr_reader :balance, :entry_station
  def initialize(balance)
    @balance = balance
    @entry_station = nil
  end

  def top_up(amount)
    check_new_balance(amount)
    @balance += amount
  end

  def in_journey?
    !@entry_station.nil?
  end

  def touch_in(entry_station)
    check_card_has_minimum_fare

    @entry_station = entry_station
    @in_journey = true
  end

  def touch_out
    @in_journey = false
    @entry_station = nil
    deduct(MINIMUM_FARE)
  end

  private

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
