module Cadet
  module Transaction

    def self.begin(db)
      db.beginTx()
    end
    def self.end(tx)
      tx.success()
      tx.close()
    end

  end
end
