require 'spec_helper'
require 'tmpdir'
require 'java'

describe Cadet do

  it "should set a node's property" do
    Dir.mktmpdir do |tmpdir|
      db = Cadet::Session.open(tmpdir)
      db.transaction do
        javad = db.get_node :Person, :name, "Javad"
        javad[:name].should == "Javad"
      end
      db.close
    end
  end

  it "should set a node's label" do
    Dir.mktmpdir do |tmpdir|
      db = Cadet::Session.open(tmpdir)
      db.transaction do
        javad = db.get_node :Person, :name, "Javad"
        javad.add_label "Member"
        javad.labels.should == ["Person", "Member"]
      end
      db.close
    end
  end

  it "should add outgoing relationship's to a node" do
    Dir.mktmpdir do |tmpdir|
      db = Cadet::Session.open(tmpdir)
      db.transaction do
        javad = db.get_node :Person, :name, "Javad"
        ellen = db.get_node :Person, :name, "Ellen"

        javad.outgoing(:knows) << ellen
        ellen.outgoing(:knows) << javad

        ellen.outgoing(:knows).to_a.should == [javad]
        javad.outgoing(:knows).to_a.should == [ellen]
      end
      db.close
    end
  end

end
