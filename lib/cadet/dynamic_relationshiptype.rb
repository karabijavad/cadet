module Cadet
  class DynamicRelationshipType
    @dynamic_relationship_types = {}

    def self.withName(name)
      @dynamic_relationship_types[name.to_sym] ||= org.neo4j.graphdb.DynamicRelationshipType.withName(name)
    end
  end
end
