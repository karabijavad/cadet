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

    def self.begin(db)
      db.beginTx()
    end
    def self.end(tx)
      tx.success()
      tx.close()
    end

  end
end
