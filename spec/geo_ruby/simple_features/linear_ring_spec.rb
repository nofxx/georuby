require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe LinearRing do
#  before(:each) do
#    @po = Polygon.new
#  end

  it "should instantiate" do
    lr = LinearRing.new([1.2,2.5,2.2,4.5])
    lr.should be_instance_of(LinearRing)
  end


end
