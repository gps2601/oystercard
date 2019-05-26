class Oystercard
  MAXIMUM_BALANCE = 90
  OVER_MAX_BALANCE_ERROR = 'Top up not allowed. Max balance exceeded.'.freeze
  attr_reader :balance
  def initialize(balance, in_journey = false)
    @balance = balance
    @in_journey = in_journey
  end

  def top_up(amount)
    check_new_balance(amount)
    @balance += amount
  end

  def deduct(amount)
    @balance -= amount
  end

  def in_journey?
    @in_journey
  end

  def touch_in
    @in_journey = true
  end

  def touch_out
    @in_journey = false
  end

  private

  def check_new_balance(amount)
    raise OVER_MAX_BALANCE_ERROR if @balance + amount > MAXIMUM_BALANCE
  end
end
