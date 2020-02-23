# frozen_string_literal: true

# rubocop:disable Style/ClassVars
class Station
  include InstanceCounter
  include Validation

  attr_reader :name, :trains

  @@stations = []

  validate :name, :presence
  validate :name, :type, String

  def self.all
    @@stations
  end

  def initialize(name)
    @name = name
    @trains = []
    validate!
    register_instance
    @@stations << self
  end

  def take_train(train)
    @trains << train
  end

  def train_type_list(type)
    @trains.select { |train| train.train_type == type }
  end

  def send_train(train)
    @trains.delete(train)
  end

  def all_trains
    @trains.each { |train| yield train } if block_given?
  end
end
# rubocop:enable Style/ClassVars
