GeoRuby
=======

This is intended as a holder for geometric data.
The data model roughly follows the OGC "Simple Features for SQL" specification,
so it should play nice with data returned from PostGIS or any Spatial Extensions (MongoDB, MySQL...).
It also supports various output and input formats (GeoRSS, KML, Shapefile).
GeoRuby is written in pure Ruby.

OGC:"http://www.opengis.org/docs/99-049.pdf"

If you are looking for Proj/Geos (geometric operators or reprojections) rubygem checkout: (C extension)
rgeo:"https://github.com/dazuma/rgeo"

[![Gem Version](https://badge.fury.io/rb/georuby.png)](http://badge.fury.io/rb/georuby)
[![Code Climate](https://codeclimate.com/github/nofxx/georuby.png)](https://codeclimate.com/github/nofxx/georuby)
[![Build Status](https://travis-ci.org/nofxx/georuby.png?branch=master)](https://travis-ci.org/nofxx/georuby)


Available data types
--------------------

The following geometric data types are provided :
- Point
- Line String
- Linear Ring
- Polygon
- Multi Point
- Multi Line String
- Multi Polygon
- Geometry Collection

They can be in 2D, 3DZ, 3DM, and 4D.

On top of this an Envelope class is available, to contain the bounding box of a geometry.


Installation
------------

To install the latest version, just type:

    gem install georuby


Or include on your projects`s Gemfile:

    gem 'georuby'


Optional, require if you need the functionality:


    require 'geo_ruby/shp4r/shp'    # Shapefile
    require 'geo_ruby/gpx4r/gpx'    # GPX data
    require 'geo_ruby/geojson'      # GeoJSON
    require 'geo_ruby/georss'       # GeoRSS
    require 'geo_ruby/kml'          # KML data


Use
===

Simple Examples
----------------

Creating a 3D Point:

    Point.from_x_y_z(10.0, 20.0, 5.0)


Creating a LineString:

     LineString.from_coordinates([[1,1],[2,2]],4326))


Input and output
----------------

These geometries can be input and output in WKB/EWKB/WKT/EWKT format as well as
the related HexWKB and HexEWKB formats. HexEWKB and WKB are the default form under
which geometric data is returned respectively from PostGIS and MySql.

GeoRSS Simple, GeoRSS W3CGeo, GeoRSS GML can also be input and output.
Note that they will not output valid RSS, but just the part strictly concerning
the geometry as outlined in http://www.georss.org/1/ . Since the model does
not allow multiple geometries, for geometry collections, only the first geometry
will be output. Similarly, for polygons, the GeoRSS output will only contain the outer ring.
As for W3CGeo output, only points can be output, so the first point of the geometry is chosen.
By default the Simple format is output. Envelope can also be output in these formats:
The box geometric type is chosen (except for W3CGeo, where the center of the envelope is chose).
These formats can also be input and a GeoRuby geometry will be created.
Note that it will not read a valid RSS file, only a geometry string.

On top of that, there is now support for KML output and input.
As for GeoRSS, a valid KML file will not be output, but only the geometric data.
Options <tt>:id</tt>, <tt>:extrude</tt>, <tt>:tesselate</tt> and <tt>:altitude_mode</tt> can be given.
Note that if the <tt>:altitude_mode</tt> option is not passed or set to <tt>clampToGround</tt>,
the altitude data will not be output even if present. Envelopes output a LatLonAltBox instead of a geometry.
For the output, the following geometric types are supported : Point, LineString, Polygon.


SHP reading et writing
---

Georuby has support for reading ESRI shapefiles (http://www.esri.com/library/whitepapers/pdfs/shapefile.pdf).
A tool called <tt>shp2sql.rb</tt> is also provided: it shows how to use the SHP reading functionality together
with the spatial adapter plugin for Rails to import spatial features into MySQL and PostGIS.

Here is an example of Shapefile reading, that goes through all the geometries
in a file and disaply the values of the attributes :

      require 'geo_ruby/shp'

      ShpFile.open(shpfile) do |shp|
        shp.each do |shape|
          geom = shape.geometry #a GeoRuby SimpleFeature
          att_data = shape.data #a Hash
          shp.fields.each do |field|
            puts att_data[field.name]
          end
        end
      end

Support for ESRI shapefile creation and modification has been added as well.
New shapefiles can be created given a geometry type and specifications for the DBF fields.
Data can be added and removed from an existing shapefile.
An update operation is also provided for convenience: it just performs a 'delete' and an 'add',
which means the index of the modified record will change. Note that once a shapefile has been created,
GeoRuby does not allow the modification of the schema (it will probably be done in a subsequent version).

Here is an example of how to create a new Shapefile with 2 fields :

      shpfile = ShpFile.create('hello.shp',ShpType::POINT,[Dbf::Field.new("Hoyoyo","C",10),Dbf::Field.new("Boyoul","N",10,0)])

The file is then open for reading and writing.

Here is an example of how to write to a shapefile (created or not with GeoRuby) :

      shpfile = ShpFile.open('places.shp')
      shpfile.transaction do |tr|
        tr.add(ShpRecord.new(Point.from_x_y(123.4,123.4),'Hoyoyo' => "AEZ",'Bouyoul' => 45))
        tr.update(4,ShpRecord.new(Point.from_x_y(-16.67,16.41),'Hoyoyo' => "EatMe",'Bouyoul' => 42))
        tr.delete(1)
      end
      shpfile.close

Note the transaction is just there so the operations on the files can be buffered.
Nothing happens on the original files until the block has finished executing.
Calling <tt>tr.rollback</tt> at anytime during the execution will prevent the modifications.

Also currently, error reporting is minimal and it has not been tested that
thoroughly so caveat emptor and backup before performing any destructive operation.


GPX Reading
---

You can read and convert GPX Files to LineString/Polygon:

     gpxfile = GpxFile.open('tour.gpx')
     gpxfile.as_line_string
     => GeoRuby::SimpleFeatures::LineString..


GeoJSON Support
-------

Basic GeoJSON support has been implemented per v1.0 of the {spec}[http://geojson.org/geojson-spec.html].

USAGE:

 input - GeoRuby::SimpleFeatures::Geometry.from_geojson(geojson_string)
 output - call #as_geojson or #to_json on any SimpleFeature Geometry instance

TODO:
 * Refactor to support extremely large GeoJSON input streams / files. Currently
   the entire GeoJSON representation must be loaded into memory as a String
 * Improve srid/crs support on input and add support on output
 * Implement bounding-box spport per spec on input/output?
 * Improved / more tests

GeoJSON support implemented by {Marcus Mateus}[http://github.com/marcusmateus] and released courtesy {SimpliTex}[http://simplitex.com].


=== Extra Features

- Writing of ESRI shapefiles
- Reading of ESRI shapefiles
- Tool to import spatial features in MySQL and PostGIS from a SHP file


=== Acknowledgement

The SHP reading part uses the DBF library (http://rubyforge.org/projects/dbf/) by Keith Morrison (http://infused.org).
Thanks also to Pramukta Kumar and Pete Schwamb for their contributions.


== Support (Original GeoRuby gem)

Any questions, enhancement proposals, bug notifications or corrections
can be sent to mailto:guilhem.vellut@gmail.com.


=== Coming in the next versions

- Schema modification of existing shapefiles
- More error reporting when writing shapefiles
- More tests on writing shapefiles ; tests on real-world shapefiles
- Better shp2sql import tool
- Documentation
