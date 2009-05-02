= geo_ruby

Experiment with GeoRuby (http://georuby.rubyforge.org) with the fast Geo (http://geo.rubyforge.org).


== DESCRIPTION:

the objective is provide all the georuby functionalities, with time consuming calculus in C.
_this is not usable yet_

See:
GeoRuby (http://georuby.rubyforge.org)
Copyright (c) 2006 Guilhem Vellut <guilhem.vellut+georuby@gmail.com>

Geo (http://geo.rubyforge.org)
Copyright (C) 2007 Martin Kihlgren


== REQUIREMENTS:

glib:: http://www.gtk.org/

== FEATURES:

=Available data types

- Point
- Line string
- Linear ring
- Polygon
- Multi point
- Multi line string
- Multi polygon
- Geometry collection

They can be in 2D, 3DZ, 3DM, and 4D.


Geo::Point:: A 2D point providing some common geometry operations.
Geo::Line:: A 2D line consisting of 2 Geo::Points providing some common geometry operations.
Geo::Triangle:: A 2D triangle consisting of 3 Geo::Points providing some common geometry operations.
Geo::PointSet:: A Set-like container of Points.
Geo::LineSet:: A Set-like container of Lines that provides optimized versions of some common geometry operations on lines.
Geo::TriangleSet:: A Set-like container of Triangles that provides optimized versions of some common geometry operations on lines.

== Usage:

Just install the gem.

== Examples:

To find if a given line intersects a set of 100 000 other lines:

 :include:examples/intersects.rb

== License:

GeoRuby is released under the MIT license.
geo is provided under the GPL-2.
