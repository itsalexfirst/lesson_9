class Station
  include InstanceCounter
  attr_reader :name, :trains

  @@stations = []
  def self.all
    @@stations
  end

  def initialize(name)
    register_instance
    @@stations << self
    @name = name
    @trains = []
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
end
