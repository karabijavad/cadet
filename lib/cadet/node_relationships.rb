module Cadet
  class NodeRelationships
    include Enumerable
    include_package "org.neo4j.graphdb"

    def initialize(node, direction, type)
      @node = node
      @type = type
      @direction = direction
    end

    def each &block
      @node.each_relationship(@direction, @type, &block)
    end

    def ==(other)
      self.to_a == other.to_a
    end

  end
end
