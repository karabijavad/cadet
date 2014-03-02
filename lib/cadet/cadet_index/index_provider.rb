module Cadet
  module CadetIndex
    class IndexProvider

      def initialize(db)
        @db = db
        @indexes = {}
        @lucene_index = org.neo4j.index.impl.lucene.LuceneBatchInserterIndexProviderNewImpl.new(db)
      end
      def nodeIndex(label, type = {"type" => "exact"})
        @indexes[label.to_sym] ||= CadetIndex::Index.new(@lucene_index, label.to_sym, type)
      end
      def shutdown
        @indexes.each { |label, index| index.flush }
      end
    end
  end
end
