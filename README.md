[![Build Status](https://travis-ci.org/karabijavad/cadet.png?branch=master)](https://travis-ci.org/karabijavad/cadet)

Use neo4j via jruby! Nothing else needed, simply add this gem to get the power of embedded neo4j!

* Batchinsert mode supported.


super simple. you dont even need to download neo4j.

##Open a session
```ruby

require 'cadet'

Cadet::Session.open "path/to/graph.db/" do
#for a batch inserter session:
#Cadet::BatchInserter::Session.open "path/to/graph.db/" do
#bear in mind that, the database directory needs to be clean before establishing a BatchInserter session.
  transaction do
    Person_by_name("Javad").lives_in_to City_by_name("Chicago")
  end
end

```

## beginning a transaction
```ruby
transaction do
  #...
end
```
Note: transaction effictively does nothing in a BatchInserter session, as transactions are not supported in neo4j's BatchInserter (for performance reasons)

## Getting/creating a node, using label-property-value
A node can be retrieved (and implicitly created if it does not exist) via the following syntax:
```ruby
javad = Person_by_name("Javad")
```
This will search for a node with the label "Person", and with the a "name" property set to "Javad".
If a "Person" node with "name" "Javad" is not found, it will create the node, add the label "Person", and set the "name" to "javad".

## Setting / retrieving a nodes properties
A node's properties can be accessed and modified just as if the node was a hash:
```ruby
javad[:age] = 25
puts javad[:age] # 25
```

## Creating a relationship between 2 nodes
A relationship can be added between 2 nodes via the following syntax:
```ruby
javad.lives_in_to City_by_name("Chicago")
```
This returns a Cadet#Relationship object, which can then have its properties set just like a hash:
```ruby
new_relationship = javad.lives_in_to City_by_name("Chicago")
new_relationship[:from] = "2012"
new_relationship[:to]   = "ongoing"
```

Relationship creation can also be chained:
```ruby
Person_by_name("Javad").lives_in_to(City_by_name("Chicago")).city_of_to(State_by_name("Illinois")).state_of_to(Country_by_name("United States"))
```

A node's relationships can be iterated over via:
```ruby
javad.outgoing(:lives_in).each do |rel|
  #rel is a Cadet#Relationship
end

chicago.incoming(:lives_in).each do |rel|
  #rel is a Cadet#Relationship
end
```
Note: this (relationship traversal) does not work in a batch inserter session, atleast not yet.
The idea is a batch inserter session is used for writing data, as opposed to reading data
