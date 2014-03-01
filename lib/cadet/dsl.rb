module Cadet
  class DSL
    def initialize(db)
      @db = db
    end

    def method_missing(name, *args, &block)
      case name
        when /^([A-z_]*)_by_([A-z_]*)$/
            self.class.class_eval "
              def #{name}(value)
                @db.get_node :#{$1}, :#{$2}, value
              end"
            return self.send(name, *args, &block)

        when /^create_([A-z_]*)$/
          self.class.class_eval "
            def #{name}(value, indexing_property = nil)
              @db.create_node :#{$1}, value, indexing_property
            end"
          return self.send(name, *args, &block)
        else
          return @db.send(name, *args, &block)
      end
    end

  end
end
