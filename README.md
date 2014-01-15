super simple. you dont even need to download neo4j.

1. Gemfile

    ```ruby
    gem 'cadet', git: 'https://github.com/karabijavad/cadet'
    ```
2. ``` bundle install ```
3. cadet-example.rb

    ```ruby

    require 'cadet'
    require 'yaml'
    
    data = YAML.load_file('legislators-current.yaml')
    
    db = Cadet::Session.open("neo4j-community-2.0.0/data/graph.db")
    
    db.transaction do
      begin
        ["Legislator", "Party", "Gender", "State"].each {|v| db.constraint v, "name"}
      rescue Exception => e # ignore, probably just saying the constraint already exists
      end
    end
    
    
    data.each do |leg|
    
      db.transaction do
    
        l = db.get_a_Legislator "name", leg["name"]["official_full"] || "no name"
        p = db.get_a_Party "name", leg["terms"].first["party"]
        g = db.get_a_Gender "name", leg["bio"]["gender"]
        s = db.get_a_State "name", leg["terms"].first["state"]
    
        l.party p
        l.gender g
        l.represents s
    
      end
    end
    
    db.close()



    ```
4. ```bundle exec ruby```
