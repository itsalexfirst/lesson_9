# frozen_string_literal: true

class Route
  include InstanceCounter
  include Validation

  attr_reader :stations, :number

  validate :number, :presence
  validate :number, :type, String

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
end
