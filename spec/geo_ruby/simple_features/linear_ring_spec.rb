require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe LinearRing do

  it "should instantiate" do
    lr = LinearRing.new(4326)
    lr.should be_instance_of(LinearRing)
  end

  describe "Instance" do

    let(:lr) { LinearRing.from_coordinates([[10,10],[20,45],[45,10],[10, 10]],256) }

    it "should test if contains a point" do
      lr.contains_point?(Point.from_x_y(21,21)).should be_true
    end

    it "should test if not contains a point" do
      lr.contains_point?(Point.from_x_y(21,51)).should be_false
    end

  end

end
