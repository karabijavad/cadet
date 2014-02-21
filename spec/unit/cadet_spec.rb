require 'spec_helper'

describe Cadet do

  it "should set a node's property" do
    quick_neo4j do |db|
        javad = db.get_node :Person, :name, "Javad"
        javad[:name].should == "Javad"
    end
  end

  it "should set a node's label" do
    quick_neo4j do |db|
        javad = db.get_node :Person, :name, "Javad"
        javad.add_label :Member
        javad.labels.should == ["Person", "Member"]
    end
  end

  it "should add outgoing relationship's to a node" do
    quick_neo4j do |db|
        javad = db.get_node :Person, :name, "Javad"
        ellen = db.get_node :Person, :name, "Ellen"

        javad.outgoing(:knows) << ellen

        javad.outgoing(:knows).to_a.should == [ellen]
    end
  end

  it "it should accept multiple relationships" do
    quick_neo4j do |db|
      javad = db.get_a_Person_by_name "Javad"
      javad.outgoing(:lives_in) << db.get_a_City_by_name("Chicago")
      javad.outgoing(:lives_in) << db.get_a_City_by_name("Houston")
      javad.outgoing(:lives_in).to_a.should == [db.get_a_City_by_name("Chicago"), db.get_a_City_by_name("Houston")]
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
end
