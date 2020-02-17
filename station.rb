class Station
  include InstanceCounter

  attr_reader :name, :trains

  @@stations = []

  def self.all
    @@stations
  end

  def valid?
    validate!
    true
  rescue
    false
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

  private

  def validate!
    raise "Имя не может быть пустым" if name == ''
    raise "Станция с таким названием уже есть" if @@stations.find { |station| station.name == name }
  end
end
