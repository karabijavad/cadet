module Cadet
  class Relationship
    attr_accessor :underlying
    include_package "org.neo4j.graphdb"

    def initialize(relationship, db = nil)
      @db = db
      @underlying = relationship
    end

    def == other_rel
      @underlying.getId == other_rel.underlying.getId
    end

    def get_other_node(node)
      @underlying.getOtherNode(node.underlying)
    end
  end
end
