module Cadet
  module Transaction

    def self.transaction(db)
      tx = db.beginTx()
      begin
        yield tx
        tx.success()
      ensure
        tx.close()
      end
    end

  end
end
