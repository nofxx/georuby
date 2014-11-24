# -*- coding: binary -*-

require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe GeoRuby::SimpleFeatures::Geometry do

  it 'should instantiate' do
    violated unless subject
  end

  it 'should have a default srid' do
    expect(subject.srid).to eql(4326) # Geometry.default_srid)
  end

  it 'should change srid' do
    geo = GeoRuby::SimpleFeatures::Geometry.new(225)
    expect(geo.srid).to eql(225)
  end

  it 'should instantiate from hex ewkb' do
    point = GeoRuby::SimpleFeatures::Geometry.from_hex_ewkb('01010000207B000000CDCCCCCCCCCC28406666666666A64640')
    expect(point.class).to eq(GeoRuby::SimpleFeatures::Point)
    expect(point.x).to be_within(0.1).of(12.4)
  end

  it 'should output as_ewkb' do
    allow(subject).to receive(:binary_geometry_type).and_return(1)
    allow(subject).to receive(:binary_representation).and_return(1)
    expect(subject.as_ewkb).to eql("\001\001\000\000 \346\020\000\000\001")
  end

  it 'should output as_ewkb (utf8 issue)' do
    allow(subject).to receive(:binary_geometry_type).and_return(1)
    allow(subject).to receive(:binary_representation).and_return(1)
    expect(subject.as_ewkb).to eql("\x01\x01\x00\x00 \xE6\x10\x00\x00\x01")
  end
end
