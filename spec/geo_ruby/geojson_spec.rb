require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

DATA_DIR = File.dirname(__FILE__) + '/../data/geojson/'

# All geojson test examples are from the GeoJSON spec unless otherwise
# specified
#
# TODO Refactor comon test approaches into methods
# TODO Add use of contexts?
describe GeoRuby::GeojsonParser do

  it "should create a specified GeoRuby::SimpleFeatures::Point" do
    point_json = %{ { "type": "Point", "coordinates": [100.0, 0.0] } }
    point = GeoRuby::SimpleFeatures::Geometry.from_geojson(point_json)
    point.class.should eql(GeoRuby::SimpleFeatures::Point)
    point_hash = JSON.parse(point_json)
    point.to_coordinates.should eql(point_hash['coordinates'])
  end

  it "should create a specified GeoRuby::SimpleFeatures::LineString" do
    ls_json = %{ { "type": "LineString", "coordinates": [ [100.0, 0.0], [101.0, 1.0] ]} }
    line_string = GeoRuby::SimpleFeatures::Geometry.from_geojson(ls_json)
    line_string.class.should eql(GeoRuby::SimpleFeatures::LineString)
    ls_hash = JSON.parse(ls_json)
    line_string.to_coordinates.should eql(ls_hash['coordinates'])
  end

  it "should create a specified GeoRuby::SimpleFeatures::Polygon" do
    poly_json = <<-EOJ
      { "type": "Polygon",
        "coordinates": [
          [ [100.0, 0.0], [101.0, 0.0], [101.0, 1.0], [100.0, 1.0], [100.0, 0.0] ],
          [ [100.2, 0.2], [100.8, 0.2], [100.8, 0.8], [100.2, 0.8], [100.2, 0.2] ]
          ]
      }
    EOJ
    polygon = GeoRuby::SimpleFeatures::Geometry.from_geojson(poly_json)
    polygon.class.should eql(GeoRuby::SimpleFeatures::Polygon)
    polygon.rings.size.should eql(2)
    poly_hash = JSON.parse(poly_json)
    polygon.to_coordinates.should eql(poly_hash['coordinates'])
  end

  it "should create a specified GeoRuby::SimpleFeatures::MultiPoint" do
    mp_json = <<-EOJ
      { "type": "MultiPoint",
        "coordinates": [ [100.0, 0.0], [101.0, 1.0] ]
        }
    EOJ
    multi_point = GeoRuby::SimpleFeatures::Geometry.from_geojson(mp_json)
    multi_point.class.should eql(GeoRuby::SimpleFeatures::MultiPoint)
    mp_hash = JSON.parse(mp_json)
    multi_point.to_coordinates.should eql(mp_hash['coordinates'])
  end

  it "should create a specified GeoRuby::SimpleFeatures::MultiLineString" do
    mls_json = <<-EOJ
      { "type": "MultiLineString",
        "coordinates": [
            [ [100.0, 0.0], [101.0, 1.0] ],
            [ [102.0, 2.0], [103.0, 3.0] ]
          ]
      }
    EOJ
    multi_ls = GeoRuby::SimpleFeatures::Geometry.from_geojson(mls_json)
    multi_ls.class.should eql(GeoRuby::SimpleFeatures::MultiLineString)
    mls_hash = JSON.parse(mls_json)
    multi_ls.to_coordinates.should eql(mls_hash['coordinates'])
  end

  it "should create a specifiead GeoRuby::SimpleFeatures::MultiPolygon" do
    mpoly_json = <<-EOJ
      { "type": "MultiPolygon",
        "coordinates": [
          [[[102.0, 2.0], [103.0, 2.0], [103.0, 3.0], [102.0, 3.0], [102.0, 2.0]]],
          [[[100.0, 0.0], [101.0, 0.0], [101.0, 1.0], [100.0, 1.0], [100.0, 0.0]],
           [[100.2, 0.2], [100.8, 0.2], [100.8, 0.8], [100.2, 0.8], [100.2, 0.2]]]
          ]
        }
    EOJ
    mpoly = GeoRuby::SimpleFeatures::Geometry.from_geojson(mpoly_json)
    mpoly.class.should eql(GeoRuby::SimpleFeatures::MultiPolygon)
    mpoly_hash = JSON.parse(mpoly_json)
    mpoly.to_coordinates.should eql(mpoly_hash['coordinates'])
  end

  it "should create a specified GeoRuby::SimpleFeatures::GeometryCollection" do
    gcol_json = <<-EOJ
      { "type": "GeometryCollection",
        "geometries": [
          { "type": "Point",
            "coordinates": [100.0, 0.0]
            },
          { "type": "LineString",
            "coordinates": [ [101.0, 0.0], [102.0, 1.0] ]
            }
        ]
      }
    EOJ
    gcol = GeoRuby::SimpleFeatures::Geometry.from_geojson(gcol_json)
    gcol.class.should eql(GeoRuby::SimpleFeatures::GeometryCollection)
    gcol_hash = JSON.parse(gcol_json)
    gcol.geometries.each_with_index do |g,i|
      gh = gcol_hash['geometries'][i]
      g.class.should eql(GeoRuby::SimpleFeatures.const_get(gh['type']))
      g.to_coordinates.should eql(gh['coordinates'])
    end
  end

  # Feature GeoJSON test example from wikipedia entry
  it "should create a specified Feature" do
    feature_json = <<-EOJ
      {
        "type":"Feature",
        "id":"OpenLayers.Feature.Vector_314",
        "properties":{"prop0": "value0"},
        "geometry":{
          "type":"Point",
          "coordinates":[97.03125, 39.7265625]
        }
      }
    EOJ
    f = GeoRuby::SimpleFeatures::Geometry.from_geojson(feature_json)
    f.class.should eql(GeoRuby::GeojsonFeature)
    feature_hash = JSON.parse(feature_json)
    f.id.should eql(feature_hash['id'])
    f.properties.should eql(feature_hash['properties'])
    f.geometry.class.should eql(GeoRuby::SimpleFeatures.const_get(feature_hash['geometry']['type']))
    f.geometry.to_coordinates.should eql(feature_hash['geometry']['coordinates'])
  end

  it "should create a specified FeatureCollection" do
    fcol_json = File.read(DATA_DIR + 'feature_collection.json')
    fcol = GeoRuby::SimpleFeatures::Geometry.from_geojson(fcol_json)
    fcol.class.should eql(GeoRuby::GeojsonFeatureCollection)
    fcol_hash = JSON.parse(fcol_json)
    fcol.features.each_with_index do |f,i|
      fgh = fcol_hash['features'][i]['geometry']
      fg = f.geometry
      f.properties.should eql(fcol_hash['features'][i]['properties'])
      fg.class.should eql(GeoRuby::SimpleFeatures.const_get(fgh['type']))
      fg.to_coordinates.should eql(fgh['coordinates'])
    end
  end

end

