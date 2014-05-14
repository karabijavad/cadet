module Cadet
  class Node
    attr_accessor :underlying

    def initialize(node)
      @underlying = node
    end

    def add_label(label)
      @underlying.addLabel(DynamicLabel.label(label))
      self
    end
    def labels
      @underlying.getLabels().map(&:name)
    end

    def []= (property, value)
      @underlying.setProperty(property.to_java_string, value)
    end

    def [] (property)
      @underlying.getProperty(property.to_java_string)
    end

    def each_relationship(direction, type)
      @underlying.getRelationships(Directions[direction], DynamicRelationshipType.withName(type)).each do |rel|
        yield Relationship.new(rel)
      end
    end

    def create_outgoing(to, type)
      Relationship.new @underlying.createRelationshipTo(to.underlying, DynamicRelationshipType.withName(type))
    end
    def outgoing(type)
      NodePusher.new(self, :outgoing, type)
    end
    def incoming(type)
      NodePusher.new(self, :incoming, type)
    end

    def outgoing_rels(type)
      NodeRelationships.new(self, :outgoing, type)
    end
    def incoming_rels(type)
      NodeRelationships.new(self, :incoming, type)
    end

    def data
      @underlying.getPropertyKeys.each_with_object({}) {|key, result| result[key.to_sym] = self[key]}
    end
    def data=(new_data)
      new_data.each do |k, v|
        @underlying.setProperty(k.to_java_string, v)
      end
    end

    def == other_node
      @underlying.getId == other_node.underlying.getId
    end

    def method_missing(name, *args, &block)
      case name
        when /([A-z_]*)_to$/
          self.class.class_eval "
            def #{name}(value)
              create_outgoing(value, :#{$1})
            end
          "
          self.send(name, *args, &block)
        else
          raise NotImplementedError
      end
    end

  end
end
