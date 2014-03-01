module Cadet
  class Relationship
    attr_accessor :underlying

    def initialize(relationship)
      @underlying = relationship
    end

    def == other_rel
      @underlying.getId == other_rel.underlying.getId
    end

    def get_other_node(node)
      Node.new @underlying.getOtherNode(node.underlying)
    end
  end
end
