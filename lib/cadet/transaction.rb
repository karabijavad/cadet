module Cadet
  class Transaction
    attr_accessor :underlying
    include_package "org.neo4j.graphdb"

    def initialize(tx, db=nil)
      @underlying = tx
      @db = db
    end

    def method_missing(name, *args)
      if match = /^([A-z]*)_by_([A-z]*)/.match(name)
        self.class.class_eval "
          def #{name}(value)
            @db.get_node :#{match.captures[0]}, :#{match.captures[1]}, value
          end
        "
        self.send(name, *args)
      end
    end


  end
end
