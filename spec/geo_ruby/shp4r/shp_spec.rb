require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

include GeoRuby::Shp4r
include GeoRuby::SimpleFeatures

describe Shp4r do

  describe "Point" do
    before(:each) do
      @shpfile = ShpFile.open(File.dirname(__FILE__) + '/../../data/point.shp')
    end

    it "should parse ok" do
      @shpfile.record_count.should eql(2)
      @shpfile.should have(1).fields
      @shpfile.shp_type.should eql(ShpType::POINT)
    end

    it "should parse fields" do
      field = @shpfile.fields.first
      field.name.should eql("Hoyoyo")
      field.type.should eql("N")
    end

    it "should parse record 1" do
      rec = @shpfile[0]
      rec.geometry.should be_kind_of Point
      rec.geometry.x.should be_close(-90.08375, 0.00001)
      rec.geometry.y.should be_close(34.39996, 0.00001)
      rec.data["Hoyoyo"].should eql(6)
    end

    it "should parse record 2" do
      rec = @shpfile[1]
      rec.geometry.should be_kind_of Point
      rec.geometry.x.should be_close(-87.82580, 0.00001)
      rec.geometry.y.should be_close(33.36416, 0.00001)
      rec.data["Hoyoyo"].should eql(9)
    end

  end

  describe "Polyline" do
    before(:each) do
      @shpfile = ShpFile.open(File.dirname(__FILE__) + '/../../data/polyline.shp')
    end

    it "should parse ok" do
      @shpfile.record_count.should eql(1)
      @shpfile.should have(1).fields
      @shpfile.shp_type.should eql(ShpType::POLYLINE)
    end

    it "should parse fields" do
      field = @shpfile.fields.first
      field.name.should eql("Chipoto")
      # Dbf now uses the decimal to choose between int and float
      # So here is N instead of F
      field.type.should eql("N")
    end

    it "should parse record 1" do
      rec = @shpfile[0]
      rec.geometry.should be_kind_of MultiLineString
      rec.geometry.length.should eql(1)
      rec.geometry[0].length.should eql(6)
      rec.data["Chipoto"].should eql(5.678)
    end

  end

  describe "Polygon" do
    before(:each) do
      @shpfile = ShpFile.open(File.dirname(__FILE__) + '/../../data/polygon.shp')
    end

    it "should parse ok" do
      @shpfile.record_count.should eql(1)
      @shpfile.should have(1).fields
      @shpfile.shp_type.should eql(ShpType::POLYGON)
    end

    it "should parse fields" do
      field = @shpfile.fields.first
      field.name.should eql("Hello")
      field.type.should eql("C")
    end

    it "should parse record 1" do
      rec = @shpfile[0]
      rec.geometry.should be_kind_of MultiPolygon
      rec.geometry.length.should eql(1)
      rec.geometry[0].length.should eql(1)
      rec.geometry[0][0].length.should eql(7)
      rec.data["Hello"].should eql("Bouyoul!")
    end
  end

  describe "Write" do
    def cp_all_shp(file1,file2)
      FileUtils.copy(file1 + ".shp",file2 + ".shp")
      FileUtils.copy(file1 + ".shx",file2 + ".shx")
      FileUtils.copy(file1 + ".dbf",file2 + ".dbf")
    end

    def rm_all_shp(file)
      FileUtils.rm(file + ".shp")
      FileUtils.rm(file + ".shx")
      FileUtils.rm(file + ".dbf")
    end

    it "test_point" do
      cp_all_shp(File.dirname(__FILE__) + '/../../data/point',
                 File.dirname(__FILE__) + '/../../data/point2')
      shpfile = ShpFile.open(File.dirname(__FILE__) + '/../../data/point2.shp')

      shpfile.transaction do |tr|
        tr.should be_instance_of ShpTransaction
        tr.add(ShpRecord.new(Point.from_x_y(123.4,123.4),'Hoyoyo' => 5))
        tr.add(ShpRecord.new(Point.from_x_y(-16.67,16.41),'Hoyoyo' => -7))
        tr.delete(1)
      end

      shpfile.record_count.should eql(3)

      shpfile.close
      rm_all_shp(File.dirname(__FILE__) + '/../../data/point2')
    end

    it "test_linestring" do
      cp_all_shp(File.dirname(__FILE__) + '/../../data/polyline',
                 File.dirname(__FILE__) + '/../../data/polyline2')

      shpfile = ShpFile.open(File.dirname(__FILE__) + '/../../data/polyline2.shp')

      shpfile.transaction do |tr|
        tr.should be_instance_of ShpTransaction
        tr.add(ShpRecord.new(LineString.from_coordinates([[123.4,123.4],[45.6,12.3]]),'Chipoto' => 5.6778))
        tr.add(ShpRecord.new(LineString.from_coordinates([[23.4,13.4],[45.6,12.3],[12,-67]]),'Chipoto' => -7.1))
        tr.delete(0)
      end

      shpfile.record_count.should eql(2)
      shpfile.close
      rm_all_shp(File.dirname(__FILE__) + '/../../data/polyline2')
    end

    it "test_polygon" do
      cp_all_shp(File.dirname(__FILE__) + '/../../data/polygon',
                 File.dirname(__FILE__) + '/../../data/polygon2')
      shpfile = ShpFile.open(File.dirname(__FILE__) + '/../../data/polygon2.shp')

      shpfile.transaction do |tr|
        tr.should be_instance_of ShpTransaction
        tr.delete(0)
        tr.add(ShpRecord.new(Polygon.from_coordinates([[[0,0],[40,0],[40,40],[0,40],[0,0]],[[10,10],[10,20],[20,20],[10,10]]]),'Hello' => "oook"))
      end

      shpfile.record_count.should eql(1)

      shpfile.close
      rm_all_shp(File.dirname(__FILE__) + '/../../data/polygon2')
    end

    it "test_multipoint" do
      cp_all_shp(File.dirname(__FILE__) + '/../../data/multipoint',
                 File.dirname(__FILE__) + '/../../data/multipoint2')
      shpfile = ShpFile.open(File.dirname(__FILE__) + '/../../data/multipoint2.shp')

      shpfile.transaction do |tr|
        tr.should be_instance_of ShpTransaction
        tr.add(ShpRecord.new(MultiPoint.from_coordinates([[45.6,-45.1],[12.4,98.2],[51.2,-0.12],[156.12345,56.109]]),'Hello' => 5,"Hoyoyo" => "AEZAE"))
      end

      shpfile.record_count.should eql(2)

      shpfile.close
      rm_all_shp(File.dirname(__FILE__) + '/../../data/multipoint2')
    end

    it "test_multi_polygon" do
      cp_all_shp(File.dirname(__FILE__) + '/../../data/polygon',
                 File.dirname(__FILE__) + '/../../data/polygon4')

      shpfile = ShpFile.open(File.dirname(__FILE__) + '/../../data/polygon4.shp')

      shpfile.transaction do |tr|
        tr.should be_instance_of ShpTransaction
        tr.add(ShpRecord.new(MultiPolygon.from_polygons([Polygon.from_coordinates([[[0,0],[40,0],[40,40],[0,40],[0,0]],[[10,10],[10,20],[20,20],[10,10]]])]),'Hello' => "oook"))
      end

      shpfile.record_count.should eql(2)

      shpfile.close

      rm_all_shp(File.dirname(__FILE__) + '/../../data/polygon4')
    end

    it "test_rollback" do
      cp_all_shp(File.dirname(__FILE__) + '/../../data/polygon',
                 File.dirname(__FILE__) + '/../../data/polygon5')

      shpfile = ShpFile.open(File.dirname(__FILE__) + '/../../data/polygon5.shp')

      shpfile.transaction do |tr|
        tr.should be_instance_of ShpTransaction
        tr.add(ShpRecord.new(MultiPolygon.from_polygons([Polygon.from_coordinates([[[0,0],[40,0],[40,40],[0,40],[0,0]],[[10,10],[10,20],[20,20],[10,10]]])]),'Hello' => "oook"))
        tr.rollback
      end
      shpfile.record_count.should eql(1)

      shpfile.close

      rm_all_shp(File.dirname(__FILE__) + '/../../data/polygon5')

    end

    it "test_creation" do
      shpfile = ShpFile.create(File.dirname(__FILE__) + '/../../data/point3.shp',ShpType::POINT,[Dbf::Field.new("Hoyoyo","C",10,0)])
      shpfile.transaction do |tr|
        tr.add(ShpRecord.new(Point.from_x_y(123,123.4),'Hoyoyo' => "HJHJJ"))
      end
      shpfile.record_count.should eql(1)
      shpfile.close
      rm_all_shp(File.dirname(__FILE__) + '/../../data/point3')
    end

    it "test_creation_multipoint" do
      shpfile = ShpFile.create(File.dirname(__FILE__) + '/../../data/multipoint3.shp',ShpType::MULTIPOINT,[Dbf::Field.new("Hoyoyo","C",10),Dbf::Field.new("Hello","N",10)])
      shpfile.transaction do |tr|
        tr.add(ShpRecord.new(MultiPoint.from_coordinates([[123,123.4],[345,12.2]]),'Hoyoyo' => "HJHJJ","Hello" => 5))
      end
      shpfile.record_count.should eql(1)
      shpfile.close
      rm_all_shp(File.dirname(__FILE__) + '/../../data/multipoint3')
    end

  end

end
