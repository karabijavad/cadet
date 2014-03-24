module Cadet
  class Relationship
    attr_accessor :underlying

    def initialize(relationship)
      @underlying = relationship
    end

    def == other_rel
      @underlying.getId == other_rel.underlying.getId
    end

    def []= (property, value)
      @underlying.setProperty(property.to_java_string, value)
    end

    def [] (property)
      @underlying.getProperty(property.to_java_string)
    end

    def get_other_node(node)
      Node.new @underlying.getOtherNode(node.underlying)
    end

    def start_node
      Node.new @underlying.getStartNode
    end

    def end_node
      Node.new @underlying.getEndNode
    end

    def method_missing(name, *args, &block)
      case name
        when /([A-z_]*)_to$/
          self.class.class_eval "
            def #{name}(value)
              end_node.create_outgoing(value, :#{$1})
            end
          "
          self.send(name, *args, &block)
        else
          raise NotImplementedError
      end
    end

  end
end
