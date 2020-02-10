module InstanceCounter
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  module ClassMethods
    def instances_count
      @instances_count ||= 0
    end

    def instances_count=(count)
      @instances_count = count
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
