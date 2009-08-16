# Uses the dbf lib, Copyright 2006 Keith Morrison (http://infused.org)
# Modified to work as external gem now
require 'rubygems'
require 'dbf'

module GeoRuby
  module Shp4r
    Dbf = DBF

    module Dbf
      class Record
        def [](v)
          attributes[v.downcase]
        end
      end

      class Field < Column
        def initialize(name, type, length, decimal = 0)
          super(name, type, length, decimal)
        end
      end

      class Reader < Table
        alias_method :fields, :columns
        def header_length
          @columns_count
        end

        def self.open(f)
          new(f)
        end

        def close(); nil;  end
      end
    end
  end
end
