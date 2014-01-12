require 'spec_helper'

describe Cadet do

  it "should create a node" do
    db = Cadet::Session.open("./tmp")
    db.transaction do
      n = db.create_node
    end
    db.close
  end

  it "should _not_ create a node, as we are not in a transaction" do
    db = Cadet::Session.open("./tmp")
    expect { db.create_node }.to raise_error(org.neo4j.graphdb.NotInTransactionException)
    db.close
  end
end
