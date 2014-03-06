module Cadet
  class NodeTraverser
    include Enumerable

    def initialize(node, direction, type)
      @node = node
      @type = type
      @direction = direction
    end

    def each
      @node.each_relationship(@direction, @type) do |rel|
        yield rel.get_other_node(@node)
      end
    end

    def << (othernode)
      @direction == :outgoing ? @node.create_outgoing(othernode, @type) : othernode.create_outgoing(@node, @type)
    end

    def outgoing(type)
      PathTraverser.new to_a, :outgoing, type
    end
    def incoming(type)
      PathTraverser.new to_a, :incoming, type
    end

    def ==(other)
      self.to_a == other.to_a
    end

    def =~(other)
      self.to_a.sort == other.to_a.sort
    end


    def oootest(other)
      self.to_a.sort == other.to_a.sort
    end
  end
end
