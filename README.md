super simple. you dont even need to download neo4j.

1. Gemfile

    ```ruby
    gem 'cadet', git: 'https://github.com/karabijavad/cadet'
    ```
2. ``` bundle install ```
3. cadet-example.rb

    ```ruby

require 'cadet'

db = Cadet::Session.open("neo4j-community-2.0.0/data/graph.db")

db.transaction do

  javad = db.create_Person name: "Javad", age: 25
  ellen = db.create_Person name: "Ellen", age: 25

  movie = db.create_Movie name: "The Secret Life of Walter Mitty", release: 2013

  javad.likes ellen
  javad.likes movie

end

db.close()

    ```
4. ```bundle exec ruby```
