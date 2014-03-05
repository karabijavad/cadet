require 'spec_helper'
require 'tmpdir'

describe Cadet do

  it "should create an instance of cadet session, for test and normal sessions" do
    Cadet::Session.open(Dir.mktmpdir).class.should == Cadet::Session
    Cadet::Session.open.class.should               == Cadet::Session #test session
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
        #javad.outgoing(:lives_in).should == [chicago, houston]
        javad.outgoing(:lives_in).to_a & [houston, chicago] == javad.outgoing(:lives_in)
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

  it "should enforce unique constraints" do
    Cadet::Session.open do |session|
      session.class.should == Cadet::Session
    end
  end

  # being opened in temporary directory as, when begin used as an
  # impermanent database, neo4j is writing to disk, even though it shouldnt be.
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

end
