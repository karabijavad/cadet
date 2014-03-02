module Cadet
  class Transaction
    attr_accessor :underlying

    def initialize(session)
      @session = session
      @underlying = @session.begin_tx
    end

    def success
      @underlying.success
    end
    def close
      @underlying.close
    end
  end
end
