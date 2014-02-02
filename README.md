- batchinsert mode ruby based index provider 
- support for batchinsert mode!
just open the database with Cadet::BatchInserter::Session.open() instead of Cadet::Session.open()!
this no-ops transaction, simply yielding to the supplied block.

super simple. you dont even need to download neo4j.

1. Gemfile

    ```ruby
    gem 'cadet'
    ```
2. ``` bundle install ```
3. cadet-example.rb

    ```ruby

    require 'cadet'
    require 'yaml'
    
    data = YAML.load_file('legislators-current.yaml')

    #open the database, db is now used to interact with the database    
    db = Cadet::Session.open("neo4j-community-2.0.0/data/graph.db")
    
    db.transaction do
      begin
        #create unique constrains on each of these Labels' 'name' property
        ["Legislator", "Party", "Gender", "State"].each {|v| db.constraint v, "name"}
      rescue Exception => e # ignore, probably just saying the constraint already exists
      end
    end
    
    
    data.each do |leg|
      #begin a transaction. the transaction will automatically finish at the end of the provided block
      db.transaction do

        #get_a_X(property, value) will find a node labeled 'X', with a property of key 'property', and value 'value'
        #if the node is not found, it will create it and return it.
        l = db.get_a_Legislator_by_name leg["name"]["official_full"]
        p = db.get_a_Party_by_name      leg["terms"].first["party"]
        g = db.get_a_Gender_by_name     leg["bio"]["gender"]
        s = db.get_a_State_by_name      leg["terms"].first["state"]
    
        # automatically create relationships, where the relationship type is the method's name
        l.outgoing(:party)      << p
        l.outgoing(:gender)     << g
        l.outgoing(:represents) << s
    
      end
    end
    
    #close the database
    db.close()



    ```
4. ```bundle exec ruby```
