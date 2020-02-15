class Route
  include InstanceCounter

  attr_reader :stations, :number

  def valid?
    validate!
    true
  rescue
    false
  end

  def initialize(start_station, end_station, number)
    @stations = [start_station, end_station]
    @number = number
    validate!
    register_instance
  end

  def add(station)
    @stations.insert(-2, station)
  end

  def remove(station)
    @stations.delete(station)
  end

  private

  def validate!
    raise "Номер не может быть пустым" if number == ''
    raise "Начальная и конечная станция должны быть разными" if self.stations[0] == self.stations[-1]
  end
end
