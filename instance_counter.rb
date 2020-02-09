module InstanceCounter
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  module ClassMethods
    attr_accessor :instances_count
  end

  module InstanceMethods
    protected
    def register_instance
      self.class.instances_count ||= 0
      self.class.instances_count += 1
    end
  end
end
