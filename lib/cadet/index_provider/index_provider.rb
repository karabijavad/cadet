module Cadet
  class IndexProvider
    def initialize(db)
      @db = db
      @indexes = {}
    end
    def nodeIndex(name, type)
      @indexes[name] ||= Cadet::Index.new(name, type)
    end
  end
end

module Cadet
  class Index
    def initialize(name, type)
      @name = name
      @type = type
      @index = {}
    end
    def setCacheCapacity property, capacity
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
    end
  end
end
