
require File.dirname(__FILE__) + '/spec_helper'

describe Google::Search do
  before :each do
    @search = Google::Search.new :web, :query => 'foo'
  end
  
  it "should be enumerable" do
    @search.to_a.first.should be_a(Google::Search::Item)
  end
  
  describe "#initialize" do
    it "should accept the type of search" do
      @search.type.should == :web
    end
  end
  
  describe "#get_uri" do
    it "should return a uri" do
      @search.get_uri.should == 'http://www.google.com/uds/GwebSearch?start=0&rsz=large&hl=en&key=notsupplied&v=1.0&q=foo'
    end
    
    it "should allow arbitrary key/value pairs" do
      search = Google::Search.new :web, :query => 'foo', :foo => 'bar'
      search.get_uri.should == 'http://www.google.com/uds/GwebSearch?start=0&rsz=large&hl=en&key=notsupplied&v=1.0&q=foo&foo=bar'
    end
    
    describe "query" do
      it "should raise an error when no query string is present" do
        @search.query = nil
        lambda { @search.get_uri }.should raise_error(Google::Search::Error, /query/)
        @search.query = ''
        lambda { @search.get_uri }.should raise_error(Google::Search::Error, /query/)
      end
    end
    
    describe "version" do
      it "should raise an error when it is not present" do
        @search.version = nil
        lambda { @search.get_uri }.should raise_error(Google::Search::Error, /version/)
      end
    end
  end
  
  describe "#get_raw" do
    it "should return JSON string" do
      @search.get_raw.should be_a(String)
    end
  end
  
  describe "#get_hash" do
    it "should return JSON converted to a hash" do
      @search.stub!(:get_raw).and_return fixture('web-response.json')
      @search.get_hash.should be_a(Hash)
    end
  end
  
  describe "#get_response" do
    it "should return a Response object" do
      @search.stub!(:get_raw).and_return fixture('web-response.json')
      @search.get_response.should be_a(Google::Search::Response)
    end
    
    it "should populate #raw" do
      @search.stub!(:get_raw).and_return fixture('web-response.json')
      @search.get_response.raw.should be_a(String)
    end
  end
  
  describe "#next" do
    it "should prepare offset" do
      @search.size = :small
      @search.next.offset.should == 0; @search.get_raw
      @search.next.offset.should == 4; @search.get_raw
      @search.next.offset.should == 8
      @search.size = :large
      @search.sent = false
      @search.offset = 0
      @search.next.offset.should == 0; @search.get_raw
      @search.next.offset.should == 8; @search.get_raw
      @search.next.offset.should == 16
    end
  end
  
  describe "#response" do
    it "should alias #get_response" do
      @search.next.response.should be_a(Google::Search::Response)
    end
  end
end

describe Google::Search::Web do
  before :each do
    @search = Google::Search::Web.new :query => 'foo'  
  end
  
  describe "#get_uri" do
    describe "filter" do
      it "should default to 1" do
        @search.get_uri.should include('filter=1')
      end
      
      it "should consider anything positive as 1" do
        @search.filter = true
        @search.get_uri.should include('filter=1')
        @search.filter = 123
        @search.get_uri.should include('filter=1')
      end
      
      it "should consider anything negative as 0" do
        @search.filter = false
        @search.get_uri.should include('filter=0')
        @search.filter = nil
        @search.get_uri.should include('filter=0')
      end
    end
  end
end