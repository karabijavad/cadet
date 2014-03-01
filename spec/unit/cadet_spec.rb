require 'spec_helper'

describe Cadet do

  it "should set a node's property" do
    quick_normal_neo4j do |db|
        javad = db.get_node :Person, :name, "Javad"
        javad[:name].should == "Javad"
    end
  end

  it "should set a node's label" do
    quick_normal_neo4j do |db|
        javad = db.get_node :Person, :name, "Javad"
        javad.add_label :Member
        javad.labels.should == ["Person", "Member"]
    end
  end

  it "should add outgoing relationship's to a node" do
    quick_normal_neo4j do |db|
        javad = db.get_node :Person, :name, "Javad"
        ellen = db.get_node :Person, :name, "Ellen"

        javad.outgoing(:knows) << ellen

        javad.outgoing(:knows).should == [ellen]
    end
  end

  it "it should accept multiple relationships" do
    quick_normal_neo4j do |db|
      javad = db.get_node(:Person, :name, "Javad")
      javad.outgoing(:lives_in) << db.get_node(:City, :name, "Chicago")
      javad.outgoing(:lives_in) << db.get_node(:City, :name, "Houston")
      javad.outgoing(:lives_in).should == [db.get_node(:City, :name, "Chicago"), db.get_node(:City, :name, "Houston")]
    end
  end

  it "should allow for outgoing to be chained" do
    quick_test_neo4j do |db|
      javad       = db.get_a_Person_by_name  "Javad"
      ellen       = db.get_a_Person_by_name  "Ellen"
      trunkclub   = db.get_a_Company_by_name "Trunkclub"
      chicago     = db.get_a_City_by_name    "Chicago"
      us          = db.get_a_Country_by_name "United States"
      springfield = db.get_a_City_by_name    "Springfield"

      javad.outgoing(:works_at) << trunkclub
      trunkclub.outgoing(:located_in) << chicago
      javad.outgoing(:lives_in) << chicago
      ellen.outgoing(:lives_in) << chicago
      chicago.outgoing(:country) << us

      javad.outgoing(:works_at).outgoing(:located_in).outgoing(:country).should == [us]
      chicago.incoming(:located_in).incoming(:works_at).should == [javad]
      javad.outgoing(:works_at).outgoing(:located_in).incoming(:lives_in).should == [javad, ellen]

    end
  end

  it "should allow for node relationship's to be accessed" do
    quick_test_neo4j do |db|
      javad       = db.get_a_Person_by_name  "Javad"
      ellen       = db.get_a_Person_by_name  "Ellen"
      javad.outgoing(:knows) << ellen
      javad.incoming(:also_knows) << ellen

      javad.outgoing_rels(:knows).map{ |rel| rel.get_other_node(javad)}.should == [ellen]
      javad.incoming_rels(:also_knows).map{ |rel| rel.get_other_node(javad)}.should == [ellen]
    end
  end


  xit "should enforce unique constraints" do
    test_neo4j do |db|
      db.transaction do
        db.constraint :Person, :name
      end
      db.transaction do
        db.create_node :Person, :name, "Javad"

        expect { db.create_node :Person, :name, "Javad" }.to raise_error(org.neo4j.graphdb.ConstraintViolationException)
      end
    end
  end

  it 'should have a working dsl' do
    db = Cadet::Test::Session.open

    db.transaction do |tx|
      a = db.get_a_Person_by_name "Javad"
      b = Person_by_name "Javad"

      a.should == b
    end

    db.close
  end

  it 'should have a working dsl' do
    db = Cadet::Test::Session.open

    db.transaction do |tx|
      Person_by_name("Javad").knows_to Person_by_name("Ellen")
    end

    db.close
  end

  it 'should have a working dsl' do
    db = Cadet::Test::Session.open

    db.transaction do |tx|
      Person_by_name("Javad").lives_in_to City_by_name("Chicago")

      Person_by_name("Javad").outgoing(:lives_in).should == [City_by_name("Chicago")]
    end

    db.close
  end

end
