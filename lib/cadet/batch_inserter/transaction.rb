module Cadet
  module BatchInserter
    class Transaction < Cadet::Transaction

      def initialize(session)
        @session = session
      end

      def success
      end

      def close
      end

    end
  end
end
