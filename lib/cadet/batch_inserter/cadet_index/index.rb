module Cadet
  module BatchInserter
    module CadetIndex
      class Index
        def initialize(lucene_index, name)
          @name = name.to_sym
          @property_index = {}
          @lucene_index = lucene_index
        end

        def add(node, property, value)
          @property_index[property.to_sym] ||= {}
          @property_index[property.to_sym][value] ||= []
          @property_index[property.to_sym][value] << node
        end

        def get(property, value)
          @property_index[property.to_sym] ||= {}
          @property_index[property.to_sym][value] || []
        end

        def flush
          lucene_node_index = @lucene_index.nodeIndex(@name, {"type" => "exact"})

          @property_index.each do |property, propval_to_node_mappings|
            propval_to_node_mappings.each do |value, nodes|
              nodes.each do |node|
                lucene_node_index.add(node, {property.to_java_string => value})
              end
            end
          end
        end

      end
    end
  end
end
