# -*- coding: utf-8 -*-
require 'geo_ruby/simple_features/geometry'

module GeoRuby
	module SimpleFeatures
		# Represents Null Shape. This might come handy when dealing with degenerated
		# polygons.
		class NullShape < Geometry
			# Return empty coordinates and type when called as_json.
			def as_json(_options = {})
				{ type: 'NullShape', coordinates: [] }
			end
		end
	end
end

