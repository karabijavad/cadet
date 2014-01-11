module Cadet
  module Node
    def self.create(db)
      a = Time.now
      begin
        tx = db.beginTx()
        1000.times { db.createNode() }
        tx.success()
      ensure
        tx.close()
      end
      puts Time.now - a
    end
  end
end

