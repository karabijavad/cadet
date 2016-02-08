module Cadet
  class Traverser
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
      Traverser.new to_a, :outgoing, type
    end
    def incoming(type)
      Traverser.new to_a, :incoming, type
    end

    def ==(other)
      self.to_a == other.to_a
    end
  end
end
