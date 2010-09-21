require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe GeorssParser do
  it "test_point_creation" do
    point = Point.from_x_y(3,4)

    point.as_georss(:dialect => :simple, :elev => 45.7, :featuretypetag => "hoyoyo").gsub("\n","").should eql("<georss:point featuretypetag=\"hoyoyo\" elev=\"45.7\">4 3</georss:point>")
    point.as_georss(:dialect => :w3cgeo).gsub("\n","").should eql("<geo:lat>4</geo:lat><geo:long>3</geo:long>")
    point.as_georss(:dialect => :gml).gsub("\n","").should eql("<georss:where><gml:Point><gml:pos>4 3</gml:pos></gml:Point></georss:where>")

    point.as_kml(:id => "HOYOYO-42").gsub("\n","").should eql("<Point id=\"HOYOYO-42\"><coordinates>3,4</coordinates></Point>")
  end

  it "test_line_string" do
    ls = LineString.from_points([Point.from_lon_lat_z(12.4,-45.3,56),Point.from_lon_lat_z(45.4,41.6,45)],123,true)

    ls.as_georss.gsub("\n","").should eql("<georss:line>-45.3 12.4 41.6 45.4</georss:line>")
    ls.as_georss(:dialect => :w3cgeo).gsub("\n","").should eql("<geo:lat>-45.3</geo:lat><geo:long>12.4</geo:long>")
    ls.as_georss(:dialect => :gml).gsub("\n","").should eql("<georss:where><gml:LineString><gml:posList>-45.3 12.4 41.6 45.4</gml:posList></gml:LineString></georss:where>")

    ls.as_kml(:extrude => 1, :altitude_mode => "absolute").gsub("\n","").should eql("<LineString><extrude>1</extrude><altitudeMode>absolute</altitudeMode><coordinates>12.4,-45.3,56 45.4,41.6,45</coordinates></LineString>")
  end

  it "test_polygon" do
    linear_ring1 = LinearRing.from_coordinates([[12.4,-45.3],[45.4,41.6],[4.456,1.0698],[12.4,-45.3]],256)
    linear_ring2 = LinearRing.from_coordinates([[2.4,5.3],[5.4,1.4263],[14.46,1.06],[2.4,5.3]],256)
    polygon = Polygon.from_linear_rings([linear_ring1,linear_ring2],256)

    polygon.as_georss(:georss_ns => "hoyoyo").gsub("\n","").should eql("<hoyoyo:polygon>-45.3 12.4 41.6 45.4 1.0698 4.456 -45.3 12.4</hoyoyo:polygon>")
    polygon.as_georss(:dialect => :w3cgeo, :w3cgeo_ns => "bouyoul").gsub("\n","").should eql("<bouyoul:lat>-45.3</bouyoul:lat><bouyoul:long>12.4</bouyoul:long>")
    polygon.as_georss(:dialect => :gml).gsub("\n","").should eql("<georss:where><gml:Polygon><gml:exterior><gml:LinearRing><gml:posList>-45.3 12.4 41.6 45.4 1.0698 4.456 -45.3 12.4</gml:posList></gml:LinearRing></gml:exterior></gml:Polygon></georss:where>")

    polygon.as_kml.gsub("\n","").should eql("<Polygon><outerBoundaryIs><LinearRing><coordinates>12.4,-45.3 45.4,41.6 4.456,1.0698 12.4,-45.3</coordinates></LinearRing></outerBoundaryIs><innerBoundaryIs><LinearRing><coordinates>2.4,5.3 5.4,1.4263 14.46,1.06 2.4,5.3</coordinates></LinearRing></innerBoundaryIs></Polygon>")
  end

  it "test_geometry_collection" do
    gc = GeometryCollection.from_geometries([Point.from_x_y(4.67,45.4,256),LineString.from_coordinates([[5.7,12.45],[67.55,54]],256)],256)

    #only the first geometry is output
    gc.as_georss(:dialect => :simple,:floor => 4).gsub("\n","").should eql("<georss:point floor=\"4\">45.4 4.67</georss:point>")
    gc.as_georss(:dialect => :w3cgeo).gsub("\n","").should eql("<geo:lat>45.4</geo:lat><geo:long>4.67</geo:long>")
    gc.as_georss(:dialect => :gml).gsub("\n","").should eql("<georss:where><gml:Point><gml:pos>45.4 4.67</gml:pos></gml:Point></georss:where>")

    gc.as_kml(:id => "HOYOYO-42").gsub("\n","").should eql("<MultiGeometry id=\"HOYOYO-42\"><Point><coordinates>4.67,45.4</coordinates></Point><LineString><coordinates>5.7,12.45 67.55,54</coordinates></LineString></MultiGeometry>")
  end

  it "test_envelope" do
    linear_ring1 = LinearRing.from_coordinates([[12,-45,5],[45,41,6],[4,1,8],[12.4,-45,3]],256,true)
    linear_ring2 = LinearRing.from_coordinates([[2,5,9],[5.4,1,-5.4],[14,1,34],[2,5,3]],256,true)
    polygon = Polygon.from_linear_rings([linear_ring1,linear_ring2],256,true)

    e = polygon.envelope

    e.as_georss(:dialect => :simple).gsub("\n","").should eql("<georss:box>-45 4 41 45</georss:box>")
    #center
    e.as_georss(:dialect => :w3cgeo).gsub("\n","").should eql("<geo:lat>-2</geo:lat><geo:long>24</geo:long>")
    e.as_georss(:dialect => :gml).gsub("\n","").should eql("<georss:where><gml:Envelope><gml:LowerCorner>-45 4</gml:LowerCorner><gml:UpperCorner>41 45</gml:UpperCorner></gml:Envelope></georss:where>")

    e.as_kml.gsub("\n","").should eql("<LatLonAltBox><north>41</north><south>-45</south><east>45</east><west>4</west><minAltitude>-5.4</minAltitude><maxAltitude>34</maxAltitude></LatLonAltBox>")
  end

  it "test_point_georss_read" do
    #W3CGeo
    str = "   <geo:lat >12.3</geo:lat >\n\t  <geo:long>   4.56</geo:long> "
    geom = Geometry.from_georss(str)
    geom.class.should eql(Point)
    geom.lat.should eql(12.3)
    geom.lon.should eql(4.56)

    str = " <geo:Point> \n \t  <geo:long>   4.56</geo:long> \n\t  <geo:lat >12.3</geo:lat > </geo:Point>  "
    geom = Geometry.from_georss(str)
    geom.class.should eql(Point)
    geom.lat.should eql(12.3)
    geom.lon.should eql(4.56)

    #gml
    str = " <georss:where> \t\r  <gml:Point  > \t <gml:pos> 4 \t 3 </gml:pos> </gml:Point> </georss:where>"
    geom = Geometry.from_georss(str)
    geom.class.should eql(Point)
    geom.lat.should eql(4.0)
    geom.lon.should eql(3.0)

    #simple
    str = "<georss:point > 4 \r\t  3 \t</georss:point >"
    geom  = Geometry.from_georss(str)
    geom.class.should eql(Point)
    geom.lat.should eql(4.0)
    geom.lon.should eql(3.0)

    #simple with tags
    str = "<georss:point featuretypetag=\"hoyoyo\"  elev=\"45.7\" \n floor=\"2\" relationshiptag=\"puyopuyo\" radius=\"42\" > 4 \n 3 \t</georss:point >"
    geom,tags = Geometry.from_georss_with_tags(str)
    geom.class.should eql(Point)
    geom.lat.should eql(4.0)
    geom.lon.should eql(3.0)
    tags.featuretypetag.should eql("hoyoyo")
    tags.elev.should eql(45.7)
    tags.relationshiptag.should eql("puyopuyo")
    tags.floor.should eql(2)
    tags.radius.should eql(42.0)
  end

  it "test_line_string_georss_read" do
    ls = LineString.from_points([Point.from_lon_lat(12.4,-45.3),Point.from_lon_lat(45.4,41.6)])

    str = "<georss:line > -45.3 12.4 \n \r41.6\t 45.4</georss:line>"
    geom  = Geometry.from_georss(str)
    geom.class.should eql(LineString)
    ls.should == geom

    str = "<georss:where><gml:LineString><gml:posList>-45.3 12.4 41.6 45.4</gml:posList></gml:LineString></georss:where>"
    geom  = Geometry.from_georss(str)
    geom.class.should eql(LineString)
    ls.should == geom
  end

  it "test_polygon_georss_read" do
    linear_ring = LinearRing.from_coordinates([[12.4,-45.3],[45.4,41.6],[4.456,1.0698],[12.4,-45.3]])
    polygon = Polygon.from_linear_rings([linear_ring])

    str = "<hoyoyo:polygon featuretypetag=\"42\"  > -45.3 12.4 41.6 \n\r 45.4 1.0698 \r 4.456 -45.3 12.4 </hoyoyo:polygon>"
    geom = Geometry.from_georss(str)
    geom.class.should eql(Polygon)
    polygon.should == geom

    str = "<georss:where>\r\t \n  <gml:Polygon><gml:exterior>   <gml:LinearRing><gml:posList> -45.3 \n\r 12.4 41.6 \n\t 45.4 1.0698 4.456 -45.3 12.4</gml:posList></gml:LinearRing></gml:exterior></gml:Polygon></georss:where>"
    geom = Geometry.from_georss(str)
    geom.class.should eql(Polygon)
    polygon.should == geom
  end

  it "test_envelope_georss_read" do
    e = Envelope.from_coordinates([[4.456,-45.3],[45.4,41.6]])

    str = "<georss:box  >-45.3 4.456 \n41.6 45.4</georss:box>"
    geom = Geometry.from_georss(str)
    geom.class.should eql(Envelope)
    geom.should == e

    str = "<georss:where><gml:Envelope><gml:lowerCorner>-45.3 \n 4.456</gml:lowerCorner><gml:upperCorner>41.6 \t\n 45.4</gml:upperCorner></gml:Envelope></georss:where>"
    geom = Geometry.from_georss(str)
    geom.class.should eql(Envelope)
    geom.should == e
  end

  it "test_kml_read" do
    g = Geometry.from_kml("<Point><coordinates>45,12,25</coordinates></Point>")
    g.should be_a Point
    g.should == Point.from_x_y_z(45,12,25)

    g = Geometry.from_kml("<LineString>
      <extrude>1</extrude>
      <tessellate>1</tessellate>
      <coordinates>
        -122.364383,37.824664,0 -122.364152,37.824322,0
      </coordinates>
    </LineString>")
    g.should be_a LineString
    g.length.should eql(2)
    g.should == LineString.from_points([Point.from_x_y_z(-122.364383,37.824664,0),Point.from_x_y_z(-122.364152,37.824322,0)],4326,true)

    g = Geometry.from_kml("<Polygon>
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
    g.should be_a Polygon
    g.length.should eql(3)
  end

  it "test_to_kml_for_point_does_not_raise_type_error_if_geom_data_not_provided" do
    point = Point.from_coordinates([1.6,2.8],123)
    lambda { point.kml_representation }.should_not raise_error(TypeError)
  end

  it "test_to_kml_for_polygon_does_not_raise_type_error_if_geom_data_not_provided" do
    polygon =  Polygon.from_coordinates([[[12.4,-45.3],[45.4,41.6],[4.456,1.0698],[12.4,-45.3]],[[2.4,5.3],[5.4,1.4263],[14.46,1.06],[2.4,5.3]]],256)
    lambda { polygon.kml_representation }.should_not raise_error(TypeError)
  end

  it "test_to_kml_for_line_string_does_not_raise_type_error_if_geom_data_not_provided" do
    ls = LineString.from_coordinates([[5.7,12.45],[67.55,54]],256)
    lambda { ls.kml_representation }.should_not raise_error(TypeError)
  end

end
