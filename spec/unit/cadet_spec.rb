require 'spec_helper'
require 'tmpdir'
require 'java'

describe Cadet do

  it "should set a node's property" do
    db = Cadet::Session.open(Dir.tmpdir)
    db.transaction do
      person = db.get_node :Person, :name, "Javad"
      person[:name].should == "Javad"
    end
    db.close
  end

  it "should set a node's label" do
    db = Cadet::Session.open(Dir.tmpdir)
    db.transaction do
      person = db.get_node :Person, :name, "Javad"
      person.add_label "Member"
      person.labels.should == ["Person", "Member"]
    end
    db.close
  end

end
