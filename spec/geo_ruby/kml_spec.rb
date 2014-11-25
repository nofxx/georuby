require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe GeoRuby::KmlParser do
  before(:all) do
    POINT = '<Point><coordinates>-82.4898187291883,34.2473206042649</coordinates></Point>'
    LINESTRING = '<LineString><coordinates>-122.365662,37.826988 -122.365202,37.826302 -122.364581,37.82655 -122.365038,37.827237</coordinates></LineString>'
    LINEARRING = '<LinearRing><coordinates>-122.365662,37.826988 -122.365202,37.826302 -122.364581,37.82655 -122.365038,37.827237 -122.365662,37.826988</coordinates></LinearRing>'
    POLYGON = '<Polygon><outerBoundaryIs><LinearRing><coordinates>-82.5961385808407,34.0134202383713 -82.6029437979289,34.0346366848087 -82.6603553035687,34.1083560439036 -82.7357807829899,34.1697961502507 -82.7425935601244,34.2055536194311 -82.3145921793097,34.4812209701586 -82.2758648198483,34.4347213073308 -82.2405017851073,34.4067761024174 -82.3327002190662,34.3417863447576 -82.2910826671599,34.2708004396966 -82.2497468801283,34.2261551348023 -82.2370438982521,34.1709424545969 -82.2569955519648,34.1119142196088 -82.3237086862075,34.0601294413679 -82.368425596693,34.0533120146082 -82.4455985300521,34.0562556252352 -82.4806178108032,34.0759686807282 -82.5334224196077,34.0620944842448 -82.5961385808407,34.0134202383713</coordinates></LinearRing></outerBoundaryIs></Polygon>'
    COMPLEX_POLYGON = '<Polygon><outerBoundaryIs><LinearRing><coordinates>-122.366278,37.818844 -122.365248,37.819267 -122.36564,37.819861 -122.366669,37.819429 -122.366278,37.818844</coordinates></LinearRing></outerBoundaryIs><innerBoundaryIs><LinearRing><coordinates>-122.366212,37.818977 -122.365424,37.819294 -122.365704,37.819731 -122.366488,37.819402 -122.366212,37.818977</coordinates></LinearRing></innerBoundaryIs></Polygon>'
    MULTIGEOMETRY = '<MultiGeometry><Polygon><outerBoundaryIs><LinearRing><coordinates>-82.5961385808407,34.0134202383713 -82.6029437979289,34.0346366848087 -82.6603553035687,34.1083560439036 -82.7357807829899,34.1697961502507 -82.7425935601244,34.2055536194311 -82.3145921793097,34.4812209701586 -82.2758648198483,34.4347213073308 -82.2405017851073,34.4067761024174 -82.3327002190662,34.3417863447576 -82.2910826671599,34.2708004396966 -82.2497468801283,34.2261551348023 -82.2370438982521,34.1709424545969 -82.2569955519648,34.1119142196088 -82.3237086862075,34.0601294413679 -82.368425596693,34.0533120146082 -82.4455985300521,34.0562556252352 -82.4806178108032,34.0759686807282 -82.5334224196077,34.0620944842448 -82.5961385808407,34.0134202383713</coordinates></LinearRing></outerBoundaryIs></Polygon><Point><coordinates>-82.4898187291883,34.2473206042649</coordinates></Point></MultiGeometry>'
    POINT3D = '<Point><coordinates>-82.4898187291883,34.2473206042649,5</coordinates></Point>'
    LINESTRING3D = '<LineString><coordinates>-122.365662,37.826988,1 -122.365202,37.826302,2 -122.364581,37.82655,3 -122.365038,37.827237,4</coordinates></LineString>'
  end

  before(:each) do
    @factory = GeoRuby::SimpleFeatures::GeometryFactory.new
    @kml_parser = described_class.new(@factory)
  end

  it 'should parse a GeoRuby::SimpleFeatures::Point correctly' do
    @kml_parser.parse(POINT)
    g = @factory.geometry
    expect(g).not_to eql(nil)
    expect(g).to be_an_instance_of(GeoRuby::SimpleFeatures::Point)
    expect(g.as_kml.gsub(/\n/, '')).to eql(POINT)
  end

  it 'should parse a GeoRuby::SimpleFeatures::LineString correctly' do
    @kml_parser.parse(LINESTRING)
    g = @factory.geometry
    expect(g).not_to eql(nil)
    expect(g).to be_an_instance_of(GeoRuby::SimpleFeatures::LineString)
    expect(g.as_kml.gsub(/\n/, '')).to eql(LINESTRING)

    @kml_parser.parse(LINEARRING)
    g = @factory.geometry
    expect(g).not_to eql(nil)
    expect(g).to be_an_instance_of(GeoRuby::SimpleFeatures::LinearRing)
    expect(g.as_kml.gsub(/\n/, '')).to eql(LINEARRING)
  end

  it 'should parse a GeoRuby::SimpleFeatures::Polygon correctly' do
    @kml_parser.parse(POLYGON)
    g = @factory.geometry
    expect(g).not_to eql(nil)
    expect(g).to be_an_instance_of(GeoRuby::SimpleFeatures::Polygon)
    expect(g.as_kml.gsub(/\n/, '')).to eql(POLYGON)

    @kml_parser.parse(COMPLEX_POLYGON)
    g = @factory.geometry
    expect(g).not_to eql(nil)
    expect(g).to be_an_instance_of(GeoRuby::SimpleFeatures::Polygon)
    expect(g.as_kml.gsub(/\n/, '')).to eql(COMPLEX_POLYGON)
  end

  it 'should parse a MultiGeometry correctly' do
    @kml_parser.parse(MULTIGEOMETRY)
    g = @factory.geometry
    expect(g).not_to eql(nil)
    expect(g.geometries.length).to eql(2)
    expect(g).to be_an_instance_of(GeoRuby::SimpleFeatures::GeometryCollection)
    expect(g.as_kml.gsub(/\n/, '')).to eql(MULTIGEOMETRY)
  end

  it 'should parse 3D geometries correctly' do
    # not testing generation because GeoRuby kml generation logic currently
    # requires additional XML nodes to actually output 3D coordinate
    # information. I might modify that behavior.
    g = @kml_parser.parse(POINT3D)
    expect(g).not_to eql(nil)
    expect(g.with_z).to eql(true)
    # g.as_kml(:altitude_mode => "clampToGround").gsub(/\n/,'')
    #  .should eql(POINT3D)

    g = @kml_parser.parse(LINESTRING3D)
    expect(g).not_to eql(nil)
    expect(g.with_z).to eql(true)
    # g.as_kml(:altitude_mode => "clampToGround").gsub(/\n/,'')
    #  .should eql(LINESTRING3D)
  end

  it 'should yield a geometries with functional bounding boxes' do
    [LINESTRING, LINEARRING, POLYGON, COMPLEX_POLYGON,
      MULTIGEOMETRY, LINESTRING3D].each do |kml|
      @kml_parser.parse(kml)
      g = @factory.geometry
      expect do
        g.bounding_box
      end.not_to raise_error
    end
  end

  it 'should yield a geometries with functional envelopes' do
    [LINESTRING, LINEARRING, POLYGON, COMPLEX_POLYGON, MULTIGEOMETRY, LINESTRING3D].each do |kml|
      @kml_parser.parse(kml)
      g = @factory.geometry
      expect do
        g.envelope.center
      end.not_to raise_error
    end
  end
end
