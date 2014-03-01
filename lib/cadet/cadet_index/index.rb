module Cadet
  module CadetIndex
    class Index
      def initialize(lucene_index, name, type)
        @name = name
        @type = type
        @index = {}
        @lucene_index = lucene_index
      end
      def add(node, property, value)
        @index[property.to_sym] ||= {}
        @index[property.to_sym][value] = node
      end
      def get(property, value)
        @index[property.to_sym] ||= {}
        [@index[property.to_sym][value]]
      end
      def flush
        index = @lucene_index.nodeIndex(@name, @type)

        @index.each do |property, mappings|
          mappings.each do |value, node|
            index.add(node, {property.to_java_string => value})
          end
        end
      end
    end
  end
end
