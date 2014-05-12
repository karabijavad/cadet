module Cadet
  module PropertyContainer
    def []= (property, value)
      set_property property, value
    end

    def [] (property)
      get_property property
    end
    def set_property(property, value)
      @underlying.setProperty(property.to_java_string, value)
    end

    def get_property(property)
      @underlying.getProperty(property.to_java_string)
    end
  end
end
