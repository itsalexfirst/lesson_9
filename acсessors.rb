module Acсessors
  def attr_accessor_with_history(*names)
    names.each do |name|
      var_name = "@#{name}".to_sym
      var_name_history = "@#{name}_history".to_sym

      define_method("#{name}_history") { instance_variable_get(var_name_history) }

      define_method(name) { instance_variable_get(var_name) }

      define_method("#{name}=".to_sym) do |value|
        history = instance_variable_get(var_name_history) || []
        history << instance_variable_get(var_name) || []
        instance_variable_set(var_name_history, history)
        instance_variable_set(var_name, value)
      end
    end
  end

  def strong_attr_accessor(name, class_name)
    var_name = "@#{name}".to_sym

    define_method(name) { instance_variable_get(var_name) }

    define_method("#{name}=".to_sym) do |value|
      raise 'Значение не соответствует типу переменной' unless value.class == class_name
      instance_variable_set(var_name, value)
    end
  end
end

