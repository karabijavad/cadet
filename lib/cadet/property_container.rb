module Cadet
  class PropertyContainer #subclasses must implement set_property, get_property

    def []= (property, value)
      set_property property, value
    end

    def [] (property)
      get_property property
    end

  end
end