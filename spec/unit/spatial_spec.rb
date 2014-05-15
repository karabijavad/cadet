require 'spec_helper'

describe Cadet::Spatial do
  it "it should accept multiple relationships" do
    Cadet::Session.open do |sess|
      transaction do
        javad   = Person_by_name("Javad")
        chicago = City_by_name("Chicago")
        houston = City_by_name("Houston")

        javad.lives_in_to chicago
        javad.born_in_to houston

        Cadet::Spatial::Session.open(sess) do
          layer = get_point_layer "cities"

          chicago[:lat], chicago[:lon] = 41.9793333, -87.9073889
          houston[:lat], houston[:lon] = 29.6454186, -95.2788889

          layer.add chicago, "city", "chicago"
          layer.add houston, "city", "houston"

          layer.within_distance_km([41.9793333, -87.9073889], 1).should == [chicago]
          layer.within_distance_km([29.6454186, -95.2788889], 1).should == [houston]


        end
     end
    end
  end

end
