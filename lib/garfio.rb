module Garfio
  class GarfioHooks
    attr_reader :hook_before, :hook_after
    def initialize(&block)
      instance_eval &block
    end

    private
    [:before, :after].each do |name|
      define_method name do |method_name|
        instance_variable_set("@hook_#{name}", method_name)
      end
    end
  end

  def set_hook(original_method, &block)
    gar = GarfioHooks.new &block
    send :alias_method, "old_#{original_method}", original_method
    send :define_method, original_method do
      send(gar.hook_before) if gar.hook_before
      send "old_#{original_method}"
      send(gar.hook_after) if gar.hook_after
    end
  end
end