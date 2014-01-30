module Cadet
  module CadetIndex
    class Index
      def initialize(lucene_index, name, type)
        @name = name
        @type = type
        @index = {}
        @lucene_index = lucene_index
      end
      def add(node, prop)
        @index[prop.first[0]] ||= {}
        @index[prop.first[0]][prop.first[1]] = node
      end
      def get(property, value)
        @index[property] ||= {}
        [@index[property][value]]
      end
      def flush
        index = @lucene_index.nodeIndex @name, @type
        @index.each do |property, mappings|
          mappings.each do |value, node|
            index.add(node, {property => value})
          end
        end
      end
    end
  end
end
