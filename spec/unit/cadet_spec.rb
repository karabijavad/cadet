require 'spec_helper'

describe Cadet do
  it "should open a session" do
    db = Cadet::Session.open("./tmp")
  end
end
