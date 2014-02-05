module Cadet
  class DynamicRelationshipType
    @dynamic_relationship_types = {}


    def self.withName(name)
      r = @dynamic_relationship_types[name]
      unless r
        r = org.neo4j.graphdb.DynamicRelationshipType.withName(name)
        @dynamic_relationship_types[name] = r
      end
      r
    end

  end
end
