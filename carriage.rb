class Carriage
  include ManufacturingCompany

  attr_reader :type

  def initialize(number, type)
    @number = number
    @type = type
  end
end
