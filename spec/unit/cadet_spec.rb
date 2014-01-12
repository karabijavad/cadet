require 'spec_helper'

describe Cadet do
  let (:db) {Cadet::Session.open("./tmp")}

  it "should create a node" do
    db.transaction do
      n = db.create_node
    end
  end
end
