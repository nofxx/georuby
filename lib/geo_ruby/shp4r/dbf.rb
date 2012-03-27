# Uses the dbf lib, Copyright 2006 Keith Morrison (http://infused.org)
# Modified to work as external gem now
require 'rubygems'
begin
  require 'dbf'
rescue LoadError
  puts "You've loaded GeoRuby SHP Support."
  puts "Please install the gem 'dbf' to use it. `gem install dbf`"
end

module GeoRuby
  module Shp4r
    Dbf = DBF

    module Dbf
      class Record
        def [](v)
          attributes[v]
        end
      end

      class Field < Column::Base
        def initialize(name, type, length, decimal = 0, version=1, encoding=nil)
          super(name, type, length, decimal, version, encoding)
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
