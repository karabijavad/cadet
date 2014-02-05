module Cadet
  class DynamicLabel
    @dynamic_labels = {}

    def self.label(name)
      l = @dynamic_labels[name]
      unless l
        l = org.neo4j.graphdb.DynamicLabel.label(name)
        @dynamic_labels[name] = l
      end
      l
    end
  end
end