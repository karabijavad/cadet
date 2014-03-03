[![Build Status](https://travis-ci.org/karabijavad/cadet.png?branch=master)](https://travis-ci.org/karabijavad/cadet)

Use neo4j via jruby! Nothing else needed, simply add this gem to get the power of embedded neo4j!

* Batchinsert mode supported.


super simple. you dont even need to download neo4j.


```ruby

require 'cadet'

Cadet::Session.open "path/to/graph.db/") do
  transaction do
    Person_by_name("Javad").lives_in_to City_by_name("Chicago")
  end
end


```

Batch insert mode can be used by simply using Cadet::BatchInserter::Session instead of Cadet::Session!
None of your code needs to change.
