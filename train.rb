class Train
  include ManufacturingCompany
  include InstanceCounter

  attr_reader :number, :carriage, :type, :current_route
  attr_accessor :current_station

  TRAIN_NUMBER_FORMAT = /^[a-z0-9]{3}-?[a-z0-9]{2}$/i

  @@trains = {}

  def self.find(number)
    @@trains[number]
  end

  def valid?
    validate!
    true
  rescue
    false
  end

  def initialize(number, type)
    @number = number
    @type = type
    @carriages = []
    @speed = 0
    @current_route = nil
    validate!
    register_instance
    @@trains[number] = self
  end

  def add_speed(plus_speed)
    @speed += plus_speed
  end

  def current_speed
    @speed
  end

  def stop
    @speed = 0
  end

  def add_carriage(carriage)
    @carriages << carriage if @speed == 0
  end

  def remove_carriage
    @carriages.pop if @speed == 0
  end

  def add_route(current_route)
    @current_route = current_route
    @current_route.stations.first.take_train(self)
  end

  def current_station
    @current_route.stations.find { |station| station.trains.include?(self) }
  end

  def prev_station
    @current_route.stations[current_station_index - 1] if current_station != @current_route.stations.first
  end

  def next_station
    @current_route.stations[current_station_index + 1] if current_station != @current_route.stations.last
  end

  def go_next
    return unless next_station
    departure_station = current_station
    next_station.take_train(self)
    departure_station.send_train(self)
  end

  def go_prev
    return unless prev_station
    departure_station = current_station
    prev_station.take_train(self)
    departure_station.send_train(self)
  end

  private

  def validate!
    raise "Непрвильный формат номера поезда ХХХ-ХХ" if number !~ TRAIN_NUMBER_FORMAT
    raise "Поезд с таким номером уже есть" if @@trains[number] != nil
  end

  def current_station_index
    @current_route.stations.index(current_station)
  end


end
