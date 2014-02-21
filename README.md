[![Build Status](https://travis-ci.org/karabijavad/cadet.png?branch=master)](https://travis-ci.org/karabijavad/cadet)

Use neo4j via jruby! Nothing else needed, simply add this gem to get the power of embedded neo4j!

* Batchinsert mode supported. 


super simple. you dont even need to download neo4j.


```ruby

require 'cadet'

#open the database, db is now used to interact with the database
db = Cadet::Session.open("neo4j-community-2.0.0/data/graph.db")
  #begin a transaction. the transaction will automatically finish at the end of the provided block
  db.transaction do
    me = db.get_a_Person_by_name "Javad"
    chicago = db.get_a_City_by_name "Chicago"
    
    me.outgoing(:lives_in) << chicago
  end
end

#close the database
db.close

```

Batch insert mode can be used by simply using Cadet::BatchInserter::Session instead of Cadet::Session!
None of your code needs to change.
