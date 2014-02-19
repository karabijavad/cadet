module Cadet
  class DynamicRelationshipType
    @dynamic_relationship_types = {}

    def self.withName(name)
      @dynamic_relationship_types[name] ||= org.neo4j.graphdb.DynamicRelationshipType.withName(name.to_s)
    end
  end
end
