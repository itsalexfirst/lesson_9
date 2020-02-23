# frozen_string_literal: true
require_relative 'validation'
require_relative 'manufacturing_company'
require_relative 'instance_counter'
require_relative 'train'
require_relative 'route'
require_relative 'station'
require_relative 'passenger_train'
require_relative 'cargo_train'
require_relative 'carriage'
require_relative 'cargo_carriage'
require_relative 'passenger_carriage'
require_relative 'railway'

railway = Railway.new
railway.seed
railway.start
