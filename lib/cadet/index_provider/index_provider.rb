require 'index/index'

module Cadet
  module CadetIndex
      class IndexProvider
      def initialize(db)
        @db = db
        @indexes = {}
        @lucene_index = org.neo4j.index.impl.lucene.LuceneBatchInserterIndexProviderNewImpl.new(db)
      end
      def nodeIndex(name, type)
        @indexes[name] ||= Cadet::IndexProvider::Index.new(@lucene_index, name, type)
      end
      def shutdown
        @indexes.each do |name, index|
          index.flush
        end
      end
    end
  end
end
