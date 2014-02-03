module Cadet
  class PropertyContainer

    def [](key)
      get_property key
    end
    def []=(key, value)
      set_property key, value
    end

  end
end