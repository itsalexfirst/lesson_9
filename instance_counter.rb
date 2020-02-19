# frozen_string_literal: true

module InstanceCounter
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  module ClassMethods
    attr_writer :instances_count

    def instances_count
      @instances_count ||= 0
    end
  end

  module InstanceMethods
    protected

    def register_instance
      self.class.instances_count ||= 0
      self.class.instances_count += 1
    end
  end
end
