module Validation
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods

    #base.class_eval do
    #  def self.inherited(subclass)
    #    subclass.validations = validations.dup
    #  end
    #end
  end



  module ClassMethods
    attr_accessor :validations

    def validate(name, validation, arg = nil)
      @validations ||= []
      @validations << {name: name, validation: validation, arg: arg}
    end
  end

  module InstanceMethods
    def valid?
      validate!
      true
    rescue StandardError
      false
    end

    def validate!
      self.class.validations.each do |validation_arg|
        validation = "validate_#{validation_arg[:validation]}".to_sym
        name = instance_variable_get("@#{validation_arg[:name]}")
        arg = validation_arg[:arg]
        send(validation, name, arg)
      end
    end

    protected

    def validate_presence(name, arg)
      raise 'Имя не может быть пустым' if name == nil || name == ''
    end

    def validate_format(name, regx)
      raise 'Неправильный формат' if name !~ regx
    end

    def validate_type(name, class_name)
      raise 'Неправильный тип' unless name.class == class_name
    end
  end
end
