module Cadet
  class DynamicLabel
    @dynamic_labels = {}

    def self.label(name)
      name = name.to_s
      @dynamic_labels[name] ||= org.neo4j.graphdb.DynamicLabel.label(name)
    end
  end
end