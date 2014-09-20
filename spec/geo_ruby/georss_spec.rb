require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

RSS_DATA_DIR = File.dirname(__FILE__) + '/../data/georss/'

describe GeoRuby::GeorssParser do

  it "should parse an rss file" do
    geo = subject.parse(File.read(RSS_DATA_DIR + "/w3c.xml"))
    expect(geo).to be_a GeoRuby::SimpleFeatures::Point
  end

  it "test_point_creation" do
    point = GeoRuby::SimpleFeatures::Point.from_x_y(3,4)

    expect(point.as_georss(:dialect => :simple, :elev => 45.7, :featuretypetag => "hoyoyo").gsub("\n","")).to eql("<georss:point featuretypetag=\"hoyoyo\" elev=\"45.7\">4 3</georss:point>")
    expect(point.as_georss(:dialect => :w3cgeo).gsub("\n","")).to eql("<geo:lat>4</geo:lat><geo:long>3</geo:long>")
    expect(point.as_georss(:dialect => :gml).gsub("\n","")).to eql("<georss:where><gml:Point><gml:pos>4 3</gml:pos></gml:Point></georss:where>")

    expect(point.as_kml(:id => "HOYOYO-42").gsub("\n","")).to eql("<Point id=\"HOYOYO-42\"><coordinates>3,4</coordinates></Point>")
  end

  it "test_line_string" do
    ls = GeoRuby::SimpleFeatures::LineString.from_points([GeoRuby::SimpleFeatures::Point.from_lon_lat_z(12.4,-45.3,56),GeoRuby::SimpleFeatures::Point.from_lon_lat_z(45.4,41.6,45)],123,true)

    expect(ls.as_georss.gsub("\n","")).to eql("<georss:line>-45.3 12.4 41.6 45.4</georss:line>")
    expect(ls.as_georss(:dialect => :w3cgeo).gsub("\n","")).to eql("<geo:lat>-45.3</geo:lat><geo:long>12.4</geo:long>")
    expect(ls.as_georss(:dialect => :gml).gsub("\n","")).to eql("<georss:where><gml:LineString><gml:posList>-45.3 12.4 41.6 45.4</gml:posList></gml:LineString></georss:where>")

    expect(ls.as_kml(:extrude => 1, :altitude_mode => "absolute").gsub("\n","")).to eql("<LineString><extrude>1</extrude><altitudeMode>absolute</altitudeMode><coordinates>12.4,-45.3,56 45.4,41.6,45</coordinates></LineString>")
  end

  it "test_polygon" do
    linear_ring1 = GeoRuby::SimpleFeatures::LinearRing.from_coordinates([[12.4,-45.3],[45.4,41.6],[4.456,1.0698],[12.4,-45.3]],256)
    linear_ring2 = GeoRuby::SimpleFeatures::LinearRing.from_coordinates([[2.4,5.3],[5.4,1.4263],[14.46,1.06],[2.4,5.3]],256)
    polygon = GeoRuby::SimpleFeatures::Polygon.from_linear_rings([linear_ring1,linear_ring2],256)

    expect(polygon.as_georss(:georss_ns => "hoyoyo").gsub("\n","")).to eql("<hoyoyo:polygon>-45.3 12.4 41.6 45.4 1.0698 4.456 -45.3 12.4</hoyoyo:polygon>")
    expect(polygon.as_georss(:dialect => :w3cgeo, :w3cgeo_ns => "bouyoul").gsub("\n","")).to eql("<bouyoul:lat>-45.3</bouyoul:lat><bouyoul:long>12.4</bouyoul:long>")
    expect(polygon.as_georss(:dialect => :gml).gsub("\n","")).to eql("<georss:where><gml:Polygon><gml:exterior><gml:LinearRing><gml:posList>-45.3 12.4 41.6 45.4 1.0698 4.456 -45.3 12.4</gml:posList></gml:LinearRing></gml:exterior></gml:Polygon></georss:where>")

    expect(polygon.as_kml.gsub("\n","")).to eql("<Polygon><outerBoundaryIs><LinearRing><coordinates>12.4,-45.3 45.4,41.6 4.456,1.0698 12.4,-45.3</coordinates></LinearRing></outerBoundaryIs><innerBoundaryIs><LinearRing><coordinates>2.4,5.3 5.4,1.4263 14.46,1.06 2.4,5.3</coordinates></LinearRing></innerBoundaryIs></Polygon>")
  end

  it "test_geometry_collection" do
    gc = GeoRuby::SimpleFeatures::GeometryCollection.from_geometries([GeoRuby::SimpleFeatures::Point.from_x_y(4.67,45.4,256),GeoRuby::SimpleFeatures::LineString.from_coordinates([[5.7,12.45],[67.55,54]],256)],256)

    #only the first geometry is output
    expect(gc.as_georss(:dialect => :simple,:floor => 4).gsub("\n","")).to eql("<georss:point floor=\"4\">45.4 4.67</georss:point>")
    expect(gc.as_georss(:dialect => :w3cgeo).gsub("\n","")).to eql("<geo:lat>45.4</geo:lat><geo:long>4.67</geo:long>")
    expect(gc.as_georss(:dialect => :gml).gsub("\n","")).to eql("<georss:where><gml:Point><gml:pos>45.4 4.67</gml:pos></gml:Point></georss:where>")

    expect(gc.as_kml(:id => "HOYOYO-42").gsub("\n","")).to eql("<MultiGeometry id=\"HOYOYO-42\"><Point><coordinates>4.67,45.4</coordinates></Point><LineString><coordinates>5.7,12.45 67.55,54</coordinates></LineString></MultiGeometry>")
  end

  it "test_envelope" do
    linear_ring1 = GeoRuby::SimpleFeatures::LinearRing.from_coordinates([[12,-45,5],[45,41,6],[4,1,8],[12.4,-45,3]],256,true)
    linear_ring2 = GeoRuby::SimpleFeatures::LinearRing.from_coordinates([[2,5,9],[5.4,1,-5.4],[14,1,34],[2,5,3]],256,true)
    polygon = GeoRuby::SimpleFeatures::Polygon.from_linear_rings([linear_ring1,linear_ring2],256,true)

    e = polygon.envelope

    expect(e.as_georss(:dialect => :simple).gsub("\n","")).to eql("<georss:box>-45 4 41 45</georss:box>")
    #center
    expect(e.as_georss(:dialect => :w3cgeo).gsub("\n","")).to eql("<geo:lat>-2</geo:lat><geo:long>24</geo:long>")
    expect(e.as_georss(:dialect => :gml).gsub("\n","")).to eql("<georss:where><gml:Envelope><gml:LowerCorner>-45 4</gml:LowerCorner><gml:UpperCorner>41 45</gml:UpperCorner></gml:Envelope></georss:where>")

    expect(e.as_kml.gsub("\n","")).to eql("<LatLonAltBox><north>41</north><south>-45</south><east>45</east><west>4</west><minAltitude>-5.4</minAltitude><maxAltitude>34</maxAltitude></LatLonAltBox>")
  end

  it "test_point_georss_read" do
    #W3CGeo
    str = "   <geo:lat >12.3</geo:lat >\n\t  <geo:long>   4.56</geo:long> "
    geom = GeoRuby::SimpleFeatures::Geometry.from_georss(str)
    expect(geom.class).to eql(GeoRuby::SimpleFeatures::Point)
    expect(geom.lat).to eql(12.3)
    expect(geom.lon).to eql(4.56)

    str = " <geo:Point> \n \t  <geo:long>   4.56</geo:long> \n\t  <geo:lat >12.3</geo:lat > </geo:Point>  "
    geom = GeoRuby::SimpleFeatures::Geometry.from_georss(str)
    expect(geom.class).to eql(GeoRuby::SimpleFeatures::Point)
    expect(geom.lat).to eql(12.3)
    expect(geom.lon).to eql(4.56)

    #gml
    str = " <georss:where> \t\r  <gml:Point  > \t <gml:pos> 4 \t 3 </gml:pos> </gml:Point> </georss:where>"
    geom = GeoRuby::SimpleFeatures::Geometry.from_georss(str)
    expect(geom.class).to eql(GeoRuby::SimpleFeatures::Point)
    expect(geom.lat).to eql(4.0)
    expect(geom.lon).to eql(3.0)

    #simple
    str = "<georss:point > 4 \r\t  3 \t</georss:point >"
    geom  = GeoRuby::SimpleFeatures::Geometry.from_georss(str)
    expect(geom.class).to eql(GeoRuby::SimpleFeatures::Point)
    expect(geom.lat).to eql(4.0)
    expect(geom.lon).to eql(3.0)

    #simple with tags
    str = "<georss:point featuretypetag=\"hoyoyo\"  elev=\"45.7\" \n floor=\"2\" relationshiptag=\"puyopuyo\" radius=\"42\" > 4 \n 3 \t</georss:point >"
    geom,tags = GeoRuby::SimpleFeatures::Geometry.from_georss_with_tags(str)
    expect(geom.class).to eql(GeoRuby::SimpleFeatures::Point)
    expect(geom.lat).to eql(4.0)
    expect(geom.lon).to eql(3.0)
    expect(tags.featuretypetag).to eql("hoyoyo")
    expect(tags.elev).to eql(45.7)
    expect(tags.relationshiptag).to eql("puyopuyo")
    expect(tags.floor).to eql(2)
    expect(tags.radius).to eql(42.0)
  end

  it "test_line_string_georss_read" do
    ls = GeoRuby::SimpleFeatures::LineString.from_points([GeoRuby::SimpleFeatures::Point.from_lon_lat(12.4,-45.3),GeoRuby::SimpleFeatures::Point.from_lon_lat(45.4,41.6)])

    str = "<georss:line > -45.3 12.4 \n \r41.6\t 45.4</georss:line>"
    geom  = GeoRuby::SimpleFeatures::Geometry.from_georss(str)
    expect(geom.class).to eql(GeoRuby::SimpleFeatures::LineString)
    expect(ls).to eq(geom)

    str = "<georss:where><gml:LineString><gml:posList>-45.3 12.4 41.6 45.4</gml:posList></gml:LineString></georss:where>"
    geom = GeoRuby::SimpleFeatures::Geometry.from_georss(str)
    expect(geom.class).to eql(GeoRuby::SimpleFeatures::LineString)
    expect(ls).to eq(geom)
  end

  it "test_polygon_georss_read" do
    linear_ring = GeoRuby::SimpleFeatures::LinearRing.from_coordinates([[12.4,-45.3],[45.4,41.6],[4.456,1.0698],[12.4,-45.3]])
    polygon = GeoRuby::SimpleFeatures::Polygon.from_linear_rings([linear_ring])

    str = "<hoyoyo:polygon featuretypetag=\"42\"  > -45.3 12.4 41.6 \n\r 45.4 1.0698 \r 4.456 -45.3 12.4 </hoyoyo:polygon>"
    geom = GeoRuby::SimpleFeatures::Geometry.from_georss(str)
    expect(geom.class).to eql(GeoRuby::SimpleFeatures::Polygon)
    expect(polygon).to eq(geom)

    str = "<georss:where>\r\t \n  <gml:Polygon><gml:exterior>   <gml:LinearRing><gml:posList> -45.3 \n\r 12.4 41.6 \n\t 45.4 1.0698 4.456 -45.3 12.4</gml:posList></gml:LinearRing></gml:exterior></gml:Polygon></georss:where>"
    geom = GeoRuby::SimpleFeatures::Geometry.from_georss(str)
    expect(geom.class).to eql(GeoRuby::SimpleFeatures::Polygon)
    expect(polygon).to eq(geom)
  end

  it "test_envelope_georss_read" do
    e = GeoRuby::SimpleFeatures::Envelope.from_coordinates([[4.456,-45.3],[45.4,41.6]])

    str = "<georss:box  >-45.3 4.456 \n41.6 45.4</georss:box>"
    geom = GeoRuby::SimpleFeatures::Geometry.from_georss(str)
    expect(geom.class).to eql(GeoRuby::SimpleFeatures::Envelope)
    expect(geom).to eq(e)

    str = "<georss:where><gml:Envelope><gml:lowerCorner>-45.3 \n 4.456</gml:lowerCorner><gml:upperCorner>41.6 \t\n 45.4</gml:upperCorner></gml:Envelope></georss:where>"
    geom = GeoRuby::SimpleFeatures::Geometry.from_georss(str)
    expect(geom.class).to eql(GeoRuby::SimpleFeatures::Envelope)
    expect(geom).to eq(e)
  end

  it "reads KML" do
    g = GeoRuby::SimpleFeatures::Geometry.from_kml("<Point><coordinates>45,12,25</coordinates></Point>")
    expect(g).to be_a GeoRuby::SimpleFeatures::Point
    expect(g).to eq(GeoRuby::SimpleFeatures::Point.from_x_y_z('45','12','25'))

    g = GeoRuby::SimpleFeatures::Geometry.from_kml("<LineString>
      <extrude>1</extrude>
      <tessellate>1</tessellate>
      <coordinates>
        -122.364383,37.824664,0 -122.364152,37.824322,0
      </coordinates>
    </LineString>")
    expect(g).to be_a GeoRuby::SimpleFeatures::LineString
    expect(g.length).to eql(2)
    expect(g).to eq(GeoRuby::SimpleFeatures::LineString.from_points([GeoRuby::SimpleFeatures::Point.from_x_y_z('-122.364383','37.824664','0'),GeoRuby::SimpleFeatures::Point.from_x_y_z('-122.364152','37.824322','0')],4326,true))

    g = GeoRuby::SimpleFeatures::Geometry.from_kml("<Polygon>
      <extrude>1</extrude>
      <altitudeMode>relativeToGround</altitudeMode>
      <outerBoundaryIs>
        <LinearRing>
          <coordinates>
            -122.366278,37.818844,30
            -122.365248,37.819267,30
            -122.365640,37.819861,30
            -122.366669,37.819429,30
            -122.366278,37.818844,30
          </coordinates>
        </LinearRing>
      </outerBoundaryIs>
      <innerBoundaryIs>
        <LinearRing>
          <coordinates>
            -122.366212,37.818977,30
            -122.365424,37.819294,30
            -122.365704,37.819731,30
            -122.366488,37.819402,30
            -122.366212,37.818977,30
          </coordinates>
        </LinearRing>
      </innerBoundaryIs>
      <innerBoundaryIs>
        <LinearRing>
          <coordinates>
            -122.366212,37.818977,30
            -122.365424,37.819294,30
            -122.365704,37.819731,30
            -122.366488,37.819402,30
            -122.366212,37.818977,30
          </coordinates>
        </LinearRing>
      </innerBoundaryIs>
    </Polygon>")
    expect(g).to be_a GeoRuby::SimpleFeatures::Polygon
    expect(g.length).to eql(3)
  end

  it "does not raise type error if point geom data not provided" do
    point = GeoRuby::SimpleFeatures::Point.from_coordinates([1.6,2.8],123)
    expect { point.kml_representation }.not_to raise_error
  end

  it "does not raise type error if polygon geom data not provided" do
    polygon =  GeoRuby::SimpleFeatures::Polygon.from_coordinates([[[12.4,-45.3],[45.4,41.6],[4.456,1.0698],[12.4,-45.3]],[[2.4,5.3],[5.4,1.4263],[14.46,1.06],[2.4,5.3]]],256)
    expect { polygon.kml_representation }.not_to raise_error
  end

  it "does not raise type error if linestring geom data not provided" do
    ls = GeoRuby::SimpleFeatures::LineString.from_coordinates([[5.7,12.45],[67.55,54]],256)
    expect { ls.kml_representation }.not_to raise_error
  end

end
