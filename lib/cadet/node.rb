module Cadet
  class Node

    directions = {
      "incoming" => org.neo4j.graphdb.Direction[0],
      "outgoing" => org.neo4j.graphdb.Direction[1],
      "both"     => org.neo4j.graphdb.Direction[2]
    } #this is probably not the right order

    def initialize(node)
      @node = node
    end
    def node
      @node
    end
    def outgoing(to, type)
      @node.createRelationshipTo(to.node, org.neo4j.graphdb.DynamicRelationshipType.withName(type))
    end
    def addLabel(label)
      @node.addLabel(org.neo4j.graphdb.DynamicLabel.label(label))
    end

    def method_missing(name, *args)
      if name.to_s.end_with? "="
        property = name.to_s.gsub(/=$/, '')
        @node.setProperty(property, args[0])
      end
    end

    def get_single_relationship(type, dir="both")
      @node.getSingleRelationship org.neo4j.graphdb.DynamicRelationshipType.withName(type), @directions[dir]
    end

    def get_all_relationships
      @node.getRelationships()
    end
    def get_all_relationships_of_type(type)
      @node.getRelationships(org.neo4j.graphdb.DynamicRelationshipType.withName(type))
    end
    def get_all_relationships_of_type_and_dir(type, dir)
      @node.getRelationships org.neo4j.graphdb.DynamicRelationshipType.withName(type), @directions[dir]
    end

  end
end
