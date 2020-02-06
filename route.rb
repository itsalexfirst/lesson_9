class Route
  attr_reader :stations, :number

  def initialize(start_station, end_station, number)
    @stations = [start_station, end_station]
    @number = number
  end

  def add(station)
    @stations.insert(-2, station)
  end

  def remove(station)
    @stations.delete(station)
  end
end
