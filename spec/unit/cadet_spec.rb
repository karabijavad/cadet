require 'spec_helper'
require 'tmpdir'

describe Cadet do

  it "should create an instance of cadet session, for test and normal sessions" do
    Cadet::Session.open(Dir.mktmpdir).class.should == Cadet::Session
    Cadet::Session.open.class.should               == Cadet::Session #test session
  end

  it "should create an instance of cadet session, for test and normal sessions" do
    Cadet::Session.open do |session|
      self.should == session
      self.class.should == Cadet::Session
    end
  end

  it "should yield to transactions" do
    has_block_ran = false
    Cadet::Session.open do
      transaction do
        has_block_ran = true
      end
    end
    has_block_ran.should == true
  end

  it "should return the same result between get_node and Label_by_prop" do
    Cadet::Session.open do
      transaction do
        get_node(:Person, :name, "Javad").should == Person_by_name("Javad")
      end
    end
  end

  it "should set a node's label" do
    Cadet::Session.open do
      transaction do
        javad = Person_by_name("Javad")
        javad[:age] = 25

        javad[:age].should == 25
      end
    end
  end

  it "should set a node's label" do
    Cadet::Session.open do
      transaction do
        javad = Person_by_name("Javad")
        javad.add_label :Member

        javad.labels.should == ["Person", "Member"]
      end
    end
  end

  it "should add outgoing relationship's to a node" do
    Cadet::Session.open do
      transaction do
        javad = Person_by_name("Javad")
        ellen = Person_by_name("Ellen")

        javad.outgoing(:knows) << ellen

        javad.outgoing(:knows).should == [ellen]
      end
    end
  end

  it "should add outgoing relationship's to a node" do
    Cadet::Session.open do
      transaction do
        javad = Person_by_name("Javad")
        ellen = Person_by_name("Ellen")

        javad.knows_to ellen

        javad.outgoing(:knows).should == [ellen]
      end
    end
  end

  it "it should accept multiple relationships" do
    Cadet::Session.open do
      transaction do
        javad   = Person_by_name("Javad")
        chicago = City_by_name("Chicago")
        houston = City_by_name("Houston")

        javad.lives_in_to chicago
        javad.lives_in_to houston
        javad.outgoing(:lives_in).should == [chicago, houston]
      end
    end
  end

  it "should allow for outgoing to be chained" do
    Cadet::Session.open do
      transaction do
        javad       = Person_by_name  "Javad"
        ellen       = Person_by_name  "Ellen"
        trunkclub   = Company_by_name "Trunkclub"
        chicago     = City_by_name    "Chicago"
        us          = Country_by_name "United States"
        springfield = City_by_name    "Springfield"


        javad.works_at_to       trunkclub
        trunkclub.located_in_to chicago
        javad.lives_in_to       chicago
        ellen.lives_in_to       chicago
        chicago.country_to      us

        javad.outgoing(:works_at).outgoing(:located_in).outgoing(:country).should == [us]
        chicago.incoming(:located_in).incoming(:works_at).should == [javad]
        javad.outgoing(:works_at).outgoing(:located_in).incoming(:lives_in).should == [javad, ellen]
      end
    end
  end

  it "should allow for node relationship's to be accessed" do
    Cadet::Session.open do
      transaction do
        javad       = Person_by_name  "Javad"
        ellen       = Person_by_name  "Ellen"
        javad.knows_to      ellen
        ellen.also_knows_to javad

        javad.outgoing_rels(:knows).map{ |rel| rel.get_other_node(javad)}.should == [ellen]
        javad.incoming_rels(:also_knows).map{ |rel| rel.get_other_node(javad)}.should == [ellen]
      end
    end
  end

  # when using an impermanent database, neo4j is writing to disk in this test (it shouldnt).
  # so using a tmp dir instead
  it "should enforce unique constraints" do
    expect {
      Cadet::Session.open(Dir.mktmpdir) do
        transaction do
          constraint :Person, :name
        end
        transaction do
          create_node(:Person, {name: "Javad"})
          create_node(:Person, {name: "Javad"})
        end
      end
    }.to raise_error(org.neo4j.graphdb.ConstraintViolationException)
  end

  it "it should allow =~ to compare a set of nodes to a NodeRelationships, indifferent to order" do
    Cadet::Session.open do
      transaction do
        javad   = Person_by_name "Javad"
        chicago = City_by_name   "Chicago"
        houston = City_by_name   "Houston"
        memphis = City_by_name   "Memphis"

        javad.lives_in_to chicago
        javad.lives_in_to houston

        javad.outgoing(:lives_in).send("=~", [houston, chicago]).should              == true
        javad.outgoing(:lives_in).send("=~", [chicago, houston]).should              == true
        javad.outgoing(:lives_in).send("=~", [chicago, houston, memphis]).should_not == true

        javad.outgoing(:lives_in).should     =~ [chicago, houston]
        javad.outgoing(:lives_in).should     =~ [houston, chicago]
        javad.outgoing(:lives_in).should_not =~ [houston, chicago, memphis]

        javad.outgoing(:lives_in).should     == [chicago, houston]
        javad.outgoing(:lives_in).should_not == [houston, chicago]
      end
    end
  end

  it "should return the relationship created when ..._to is called on a node" do
    Cadet::Session.open do
      transaction do
        javad   = Person_by_name "Javad"
        houston = City_by_name   "Houston"

        rel = javad.home_city_to(houston)

        rel.class.should == Cadet::Relationship

        rel.start_node.should == javad
        rel.end_node.should == houston

        javad.outgoing(:home_city).should == [houston]
      end
    end
  end

  it "should allow chaining of relationship creation" do
    Cadet::Session.open do
      transaction do
        javad   = Person_by_name "Javad"
        houston = City_by_name   "Houston"
        texas   = State_by_name  "Texas"

        javad.home_city_to(houston).city_of_to(texas)

        javad.outgoing(:home_city).should == [houston]
        houston.outgoing(:city_of).should == [texas]
      end
    end
  end

  it "should return the relationship created when ..._to is called on a node" do
    Cadet::Session.open do
      transaction do
        javad   = Person_by_name "Javad"
        houston = City_by_name   "Houston"

        rel = javad.home_city_to(houston)
        rel[:birth_year]        =  1988
        rel[:birth_year].should == 1988
      end
    end
  end

  it "should allow access to the cadet database session singleton object" do
    Cadet::Session.open do |session|
      transaction do
        Cadet::Session.current_session.should == session
      end
    end
  end

  it "should retrieve the node properties with the data method" do
    Cadet::Session.open do
      transaction do
        person = Person_by_name("Javad")
        person[:age] = 25

        person.data.should == {name: "Javad", age: 25}
      end
    end
  end

  it "should retrieve the node properties with the data method" do
    Cadet::Session.open do
      transaction do
        person = Person_by_name("Javad")
        person.data = {age: 25, occupation: "Software"}

        person.data.should == {name: "Javad", age: 25, occupation: "Software"}
      end
    end
  end

  xit "should allow indexes to be created via index method" do
    Cadet::Session.open do
      transaction do
        index :Person, :name
      end

      transaction do
        pending "need to figure out how to determine the index has been added?" do
          Cadet::IndexProvider.new(@underlying)
            .find(:Person, :name).should exist
        end
      end
    end
  end
end
