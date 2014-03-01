module Cadet
  class Transaction
    attr_accessor :underlying
    include_package "org.neo4j.graphdb"

    def initialize(session)
      @session = session
      @underlying = @session.begin_tx
    end

    def method_missing(name, *args, &block)
      # for the "dsl".
      # the transaction block is instance_eval'd by this class,
      # so any missing methods are then sent to the session
      # essentially means that session.blah can then be writen blah
      @session.send(name, *args, &block)

    end

    def success
      @underlying.success
    end
    def close
      @underlying.close
    end

  end
end
