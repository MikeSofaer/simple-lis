require File.dirname(__FILE__) + '/../spec_helper'

describe "Meeting" do
  before(:each) do
    @meeting = Factory.build(:meeting)
  end
  describe "generation from XML" do
    before(:each) do
      @xml = Nokogiri(@meeting.to_xml)
    end
    it "should create a saveable Meeting from a valid XML" do
      Meeting.Parse(@xml.to_s).save!
    end
  end
end