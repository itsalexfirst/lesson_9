# frozen_string_literal: true

# rubocop:disable Metrics/ClassLength
class Railway
  def initialize
    @stations = []
    @trains = []
    @routes = []
  end

  def start
    loop do
      case start_menu
      when '0'
        break
      when '1'
        work_with_stations
      when '2'
        work_with_trains
      when '3'
        work_with_routes
      when '4'
        global_info
      else
        error_menu
      end
    end
  end

  def seed
    station1 = Station.new('st1')
    station2 = Station.new('st2')
    station3 = Station.new('st3')

    @stations = [
      station1,
      station2,
      station3
    ]

    route = Route.new(station1, station3, 'rt1')
    route.add(station2)

    @routes = [route]

    train = Train.new('trn-1p', 'passenger')
    train.add_route(route)

    @trains = [train]
  end

  def clear
    self.stations = []
    self.trains = []
    self.routes = []
  end

  private

  def stations_list
    @stations.each_index { |index| puts "#{index + 1}. #{@stations[index].name}" }
  end

  def trains_list
    @trains.each_index { |index| puts "#{index + 1}. #{@trains[index].number} #{@trains[index].type}" }
  end

  def route_list
    @routes.each_index do |index|
      puts "#{index + 1}. #{@routes[index].number}"
      stations = @routes[index].stations
      stations.each_index do |index2|
        puts "  #{index2 + 1}. #{stations[index2].name}"
      end
    end
  end

  def select_station(station_name)
    @stations.find { |station| station.name == station_name }
  end

  def select_train(train_number)
    @trains.find { |train| train.number == train_number }
  end

  def select_route(route_number)
    @routes.find { |route| route.number == route_number }
  end

  def station_exist?(station_name)
    @stations.find { |station| station.name == station_name }
  end

  def train_exist?(train_number)
    @trains.find { |train| train.number == train_number }
  end

  def route_exist?(route_number)
    @routes.find { |route| route.number == route_number }
  end

  def station_trains(name)
    trains = select_station(name).trains
    trains.each_index do |index|
      puts "#{index + 1}. #{trains[index].number}. тип: #{trains[index].type}. вагонов: #{trains[index].carriage}"
    end
  end

  def station_trains_list_menu
    print 'Введите название станции: '
    name = gets.chomp
    if station_exist?(name)
      if select_station(name).trains == []
        puts 'На станции нет поездов'
      else
        station_trains(name)
      end
    else
      puts 'Станции с таким названием нет'
    end
  end

  def station_add
    print 'Введите название станции: '
    name = gets.chomp
    @stations << Station.new(name)
  rescue StandardError => e
    puts e.message
    retry
  end

  # rubocop:disable Metrics/AbcSize
  def train_add
    print 'Введите номер поезда: '
    number = gets.chomp
    puts 'Выберите тип'
    puts '1. Пассажирский'
    puts '2. Грузовой'
    case gets.chomp
    when '1'
      @trains << PassengerTrain.new(number)
    when '2'
      @trains << CargoTrain.new(number)
    else
      error_menu
    end
  rescue StandardError => e
    puts e.message
    retry
  end

  def carriage_add(train, type)
    if type == 'cargo'
      print 'Введите объем вагона: '
      volume = gets.to_i
      number = train.carriages.size + 1
      carriage = CargoCarriage.new(number, volume)
      train.add_carriage(carriage)
    elsif type == 'passenger'
      print 'Введите количество мест: '
      seats = gets.to_i
      number = train.carriages.size + 1
      carriage = PassengerCarriage.new(number, seats)
      train.add_carriage(carriage)
    end
  end

  def carriage_load(train, type)
    puts 'Введите номер вагона:'
    number = gets.to_i
    carriage = train.carriages.find { |car| car.number == number }
    if !carriage.nil?
      if type == 'cargo'
        print 'Введите объем'
        volume = gets.to_i
        carriage.load_cargo(volume)
      elsif type == 'passenger'
        carriage.load_passenger
      end
    else
      puts 'Вагона с таким номером нет'
    end
  end

  def carriage
    print 'Введите номер поезда: '
    number = gets.chomp
    if train_exist?(number)
      train = select_train(number)
      type = select_train(number).type
      train_carriage_list(train)
      puts '1. Добавить'
      puts '2. Удалить'
      puts '3. Загрузить'
      case gets.chomp
      when '1'
        carriage_add(train, type)
      when '2'
        train.remove_carriage
      when '3'
        carriage_load(train, type)
      else
        error_menu
      end
    else
      puts 'Поезда с таким номером не существует'
    end
  end

  def train_move
    print 'Введите номер поезда: '
    number = gets.chomp
    if train_exist?(number) && !select_train(number).current_route.nil?
      puts '1. На следующую станцию'
      puts '2. На предыдущую станцию'
      case gets.chomp
      when '1'
        select_train(number).go_next
      when '2'
        select_train(number).go_prev
      else
        error_menu
      end
    else
      puts 'Поезда с таким номером не существует или маршрут не назначен'
    end
  end

  def train_add_route
    print 'Введите номер поезда: '
    number = gets.chomp
    if train_exist?(number)
      if select_train(number).current_route.nil?
        print 'введите номер маршрута: '
        index = gets.chomp
        if route_exist?(index)
          select_train(number).add_route(select_route(index))
        else
          puts 'Маршрута с таким номером нет'
        end
      else
        print 'Маршрут уже назначен'
      end
    else
      puts 'Поезда с таким номером не существует'
    end
  end

  def route_add
    print 'Введите номер маршрута: '
    number = gets.chomp
    if route_exist?(number)
      puts 'Маршрут с таким номером уже есть'
    else
      print 'Введите начальную станцию: '
      start_station = gets.chomp
      print 'Введите конечную станцию: '
      end_station = gets.chomp
      if station_exist?(start_station) && station_exist?(end_station)
        @routes << Route.new(select_station(start_station), select_station(end_station), number)
      else
        puts 'Проверте правильность ввода названий станций'
      end
    end
  rescue StandardError => e
    puts e.message
    retry
  end

  def route_edit
    print 'введите номер маршрута: '
    number = gets.chomp
    if route_exist?(number)
      print 'Введите станцию: '
      name = gets.chomp
      if station_exist?(name)
        puts '1. Добавить в маршрут'
        puts '2. Удалить из маршрута'
        case gets.chomp
        when '1'
          select_route(number).add(select_station(name))
        when '2'
          select_route(number).remove(select_station(name))
        else
          error_menu
        end
      end
    else
      puts 'Маршрута с таким номером нет'
    end
  end

  def global_info
    puts "\nСтанции"
    @stations.each do |station|
      puts "Станция: #{station.name}"
      station_trains_list(station)
    end

    puts "\nПоезда"
    @trains.each do |train|
      puts "Поезд номер: #{train.number}"
      train_carriage_list(train)
    end
  end

  def station_trains_list(station)
    station.all_trains do |train|
      puts "  Поезд номер: #{train.number}. Тип: #{train.type}. Вагонов: #{train.carriages.size}"
    end
  end

  def train_carriage_list(train)
    if train.type == 'cargo'
      train.all_carriages do |carriage|
        print "  Вагон номер: #{carriage.number}. "
        print "Тип: #{carriage.type}. "
        puts "Свободно: #{carriage.free_volume}. Занято: #{carriage.volume} объема"
      end
    elsif train.type == 'passenger'
      train.all_carriages do |carriage|
        print "  Вагон номер: #{carriage.number}. "
        print "Тип: #{carriage.type}. "
        puts "Свободно: #{carriage.free_seats}. Занято: #{carriage.seats} мест"
      end
    end
  end
  # rubocop:enable Metrics/AbcSize

  def error_menu
    puts 'Такого пункта нет'
  end

  def start_menu
    puts '1. Станции'
    puts '2. Поезда'
    puts '3. Маршруты'
    puts '4. Информация о всех станциях и поездах'
    puts '0. Выход'
    gets.chomp
  end

  def stations_menu
    puts '1. Просмотреть список станций'
    puts '2. Просмотреть список поездов на станции'
    puts '3. Создать станцию'
    puts '0. Назад'
    gets.chomp
  end

  def trains_menu
    puts '1. Список поездов'
    puts '2. Создать поезд'
    puts '3. Вагоны'
    puts '4. Переместить поезд'
    puts '5. Назначить маршрут'
    puts '0. Назад'
    gets.chomp
  end

  def routes_menu
    puts '1. Список маршрутов'
    puts '2. Редактировать маршрут'
    puts '3. Создать маршрут'
    puts '0. Назад'
    gets.chomp
  end

  def work_with_stations
    loop do
      case stations_menu
      when '0'
        break
      when '1'
        stations_list
      when '2'
        station_trains_list_menu
      when '3'
        station_add
      else
        error_menu
      end
    end
  end

  # rubocop:disable Metrics/CyclomaticComplexity
  def work_with_trains
    loop do
      case trains_menu
      when '0'
        break
      when '1'
        trains_list
      when '2'
        train_add
      when '3'
        carriage
      when '4'
        train_move
      when '5'
        train_add_route
      else
        error_menu
      end
    end
  end
  # rubocop:enable Metrics/CyclomaticComplexity

  def work_with_routes
    loop do
      case routes_menu
      when '0'
        break
      when '1'
        route_list
      when '2'
        route_edit
      when '3'
        route_add
      else
        error_menu
      end
    end
  end
end
# rubocop:enable Metrics/ClassLength
