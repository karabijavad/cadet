module Cadet
  module CadetIndex
    class IndexProvider

      def initialize(db)
        @db = db
        @indexes = {}
        @lucene_index = org.neo4j.index.impl.lucene.LuceneBatchInserterIndexProviderNewImpl.new(db)
      end
      def nodeIndex(name, type = {"type" => "exact"})
        @indexes[name.to_sym] ||= CadetIndex::Index.new(@lucene_index, name.to_sym, type)
      end
      def shutdown
        @indexes.each do |name, index|
          index.flush
        end
      end
    end
  end
end
