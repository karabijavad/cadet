module Cadet
  module BatchInserter
    module CadetIndex
      class IndexProvider

        def initialize(db)
          @indexes = {}
          @lucene_index = org.neo4j.index.impl.lucene.legacy.LuceneBatchInserterIndexProviderNewImpl.new(db)
        end

        def [](label)
          @indexes[label.to_sym] ||= CadetIndex::Index.new(@lucene_index, label.to_sym)
        end
        def shutdown
          @indexes.each do |label, index|
            index.flush
          end
        end
      end
    end
  end
end
