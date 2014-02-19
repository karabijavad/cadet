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
        property = property.to_sym
        @index[property] ||= {}
        @index[property][value] = node
      end
      def get(property, value)
        property = property.to_sym
        @index[property] ||= {}
        [@index[property][value]]
      end
      def flush
        index = @lucene_index.nodeIndex @name, @type
        @index.each do |property, mappings|
          mappings.each do |value, node|
            index.add(node, {property.to_s => value})
          end
        end
      end
    end
  end
end
