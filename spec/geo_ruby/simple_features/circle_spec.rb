# -*- coding: utf-8 -*-
require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe GeoRuby::SimpleFeatures::Circle do

  it "should instantiate" do
    subject.should be_kind_of GeoRuby::SimpleFeatures::Geometry
  end

  describe "Instance" do
    let(:circle) { GeoRuby::SimpleFeatures::Circle.new(4326) }
  end

end
