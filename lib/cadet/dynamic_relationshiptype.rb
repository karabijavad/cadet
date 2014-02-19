module Cadet
  class DynamicRelationshipType
    @dynamic_relationship_types = {}

    def self.withName(name)
      name = name.to_s
      @dynamic_relationship_types[name] ||= org.neo4j.graphdb.DynamicRelationshipType.withName(name)
    end
  end
end
