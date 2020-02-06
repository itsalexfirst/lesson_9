class PassengerTrain < Train
  def initialize(number)
    super(number, "passenger")
  end

  def add_carriage(number)
    super(number, "passenger")
  end
end
