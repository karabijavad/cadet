module Cadet
  module Proxy
    attr_accessor :underlying

    def initialize(underlying)
      @underlying = underlying
    end
  end
end
