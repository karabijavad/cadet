module Cadet
  class NodePusher
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
      Traverser.new to_a, :outgoing, type
    end
    def incoming(type)
      Traverser.new to_a, :incoming, type
    end

    def ==(other)
      self.to_a == other.to_a
    end

    def =~(other)
      self.to_a.sort_by {|n| n.underlying.getId} == other.to_a.sort_by {|n| n.underlying.getId}
    end

  end
end
