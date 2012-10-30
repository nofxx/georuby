require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe GeoRuby::SimpleFeatures::LinearRing do

  it "should instantiate" do
    lr = GeoRuby::SimpleFeatures::LinearRing.new(4326)
    lr.should be_instance_of(GeoRuby::SimpleFeatures::LinearRing)
  end

  describe "Instance" do

    let(:lr) { GeoRuby::SimpleFeatures::LinearRing.from_coordinates([[10,10],[20,45],[45,10],[10, 10]],256) }

    it "should test if contains a point" do
      lr.contains_point?(GeoRuby::SimpleFeatures::Point.from_x_y(21,21)).should be_true
    end

    it "should test if not contains a point" do
      lr.contains_point?(GeoRuby::SimpleFeatures::Point.from_x_y(21,51)).should be_false
    end

  end

end
