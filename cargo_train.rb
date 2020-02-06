class CargoTrain < Train
    def initialize(number)
    super(number, "cargo")
  end

  def add_carriage(number)
    super(number, "cargo")
  end
end
