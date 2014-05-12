module Cadet
  class Node
    include Cadet::Proxy
    include Cadet::PropertyContainer

    def add_label(label)
      @underlying.addLabel(DynamicLabel.label(label))
      self
    end
    def labels
      @underlying.getLabels().map(&:name)
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
      NodeTraverser.new(self, :outgoing, type)
    end
    def incoming(type)
      NodeTraverser.new(self, :incoming, type)
    end

    def outgoing_rels(type)
      NodeRelationships.new(self, :outgoing, type)
    end
    def incoming_rels(type)
      NodeRelationships.new(self, :incoming, type)
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
