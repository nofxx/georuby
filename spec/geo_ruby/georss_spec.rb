require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

RSS_DATA_DIR = File.dirname(__FILE__) + '/../data/georss/'

describe GeorssParser do

  it "should parse an rss file" do
    geo = GeorssParser.new.parse(File.read(RSS_DATA_DIR + "/w3c.xml"))
    geo.should be_a Point
  end



end
