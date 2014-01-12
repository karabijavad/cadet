module Cadet
  module Relationship
    def self.create(from, to, type)
      from.createRelationshipTo(to, org.neo4j.graphdb.DynamicRelationshipType.withName(type))
    end
  end
end

