module Cadet
  class PathTraverser
    include Enumerable

    def initialize(nodes, direction, type)
      @nodes = nodes
      @direction = direction
      @type = type
    end

    def each
      @nodes.each do |n|
        n.send(@direction, @type).each { |o| yield o }
      end
    end

    def outgoing(type)
      PathTraverser.new(to_a, :outgoing, type)
    end
    def incoming(type)
      PathTraverser.new(to_a, :incoming, type)
    end

    def ==(other)
      self.to_a == other.to_a
    end

    def =~(other)
      self.to_a.sort == other.to_a.sort
    end
  end
end
