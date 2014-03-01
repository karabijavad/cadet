module Cadet
  class DSL
    include_package "org.neo4j.graphdb"
    include_package "org.neo4j.graphdb.factory"
    include_package "org.neo4j.unsafe.batchinsert"
    include_package "org.neo4j.helpers.collection"

    def initialize(db)
      @db = db
    end

    def method_missing(name, *args, &block)
      if match = /^(get_a_)?([A-z_]*)_by_([A-z_]*)/.match(name)
        self.class.class_eval "
          def #{name}(value)
            @db.get_node :#{match.captures[1]}, :#{match.captures[2]}, value
          end
        "
        return self.send(name, *args, &block)
      elsif match = /^create_([A-z_]*)_on_([A-z_]*)/.match(name)
        self.class.class_eval "
          def #{name}(value)
            @db.create_node_with :#{match.captures[0]}, value, :#{match.captures[1]}
          end
        "
        return self.send(name, *args, &block)
      else
        return @db.send(name, *args, &block)
      end

    end

  end
end
