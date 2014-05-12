module Cadet
  class Relationship
    include Cadet::Proxy
    include Cadet::PropertyContainer

    def == other_rel
      @underlying.getId == other_rel.underlying.getId
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
