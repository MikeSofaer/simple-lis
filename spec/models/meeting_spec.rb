require File.dirname(__FILE__) + '/../spec_helper'

describe "Meeting" do
  before(:each) do
    @meeting = Factory.build(:meeting)
  end
  
  describe "generation from XML" do
    before(:each) do
      @xml = Hpricot(@meeting.to_xml).meeting.to_s
    end
    
    it "should create a saveable Meeting from a valid XML" do
      Meeting.parse(@xml).save!
    end
  end
end