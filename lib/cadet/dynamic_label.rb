module Cadet
  class DynamicLabel
    @dynamic_labels = {}

    def self.label(name)
      @dynamic_labels[name.to_sym] ||= org.neo4j.graphdb.DynamicLabel.label(name)
    end
  end
end
