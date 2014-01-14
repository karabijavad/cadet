super simple. you dont even need to download neo4j.

1. gem 'cadet', git: 'https://github.com/karabijavad/cadet'
2. bundle install
3. cat > cadat-example.rb

```ruby
require 'cadet'

db = Cadet::Session.open("/tmp")
db.transaction do
    a = db.create_node
    a.addLabel "Foolabel"
    a.vala = "fooa"
    a.valb = "foob"

    a = db.create_node
    a.addLabel "Barlabel"
    a.vala = "bara"
    a.valb = "barb"

    a.outgoing b, "foobar"
end
db.close()
```
3) bundle exec ruby
