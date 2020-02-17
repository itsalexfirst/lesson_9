class PassengerCarriage < Carriage
  attr_reader :total_seats, :seats, :free_seats

  def initialize(number, seats)
    super(number, 'passenger')
    total_seats = seats
    @seats = 0
    @free_seats = seats
  end

  def load_passenger
    if @free_seats >= 1
      @seats += 1
      @free_seats -= 1
    end
  end
end
