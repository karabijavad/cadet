module Cadet
  class Node
    include_package "org.neo4j.graphdb"

    directions = {
      "in"   => Direction[0],
      "out"  => Direction[1],
      "both" => Direction[2]
    }

    def initialize(node)
      @node = node
    end
    def node
      @node
    end
    def outgoing(to, type)
      @node.createRelationshipTo(to.node, DynamicRelationshipType.withName(type))
    end
    def addLabel(label)
      @node.addLabel(DynamicLabel.label(label))
      self
    end

    def method_missing(name, *args)
      if name.to_s.end_with? "="
        property = name.to_s.gsub(/=$/, '')
        @node.setProperty(property, args[0])
      end
    end

    def get_single_relationship(type, dir="both")
      @node.getSingleRelationship DynamicRelationshipType.withName(type), @directions[dir]
    end

    def get_all_relationships
      @node.getRelationships()
    end
    def get_all_relationships_of_type(type)
      @node.getRelationships(DynamicRelationshipType.withName(type))
    end
    def get_all_relationships_of_type_and_dir(type, dir)
      @node.getRelationships DynamicRelationshipType.withName(type), @directions[dir]
    end

  end
end
