# -*- coding: utf-8 -*-
require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Circle do

  it "should instantiate" do
    Circle.new.should be_kind_of Geometry
  end


  describe "Instance" do
    let(:circle) { Circle.new(4326) }
  end


end
