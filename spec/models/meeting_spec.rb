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
      Meeting.parse(@xml.to_s).save!
    end
  end
  
  context "foreign_key_valid? tests" do
    before(:each) do
      @org = Factory(:group)
    end
    
    it "should be true with valid user and target" do
      m = Factory.build(:meeting, :target => @org)
      m.foreign_key_valid?.should be_true
      lambda{ m.save! }.should_not raise_error
    end
    
    it "should be false without valid target org" do
      m = Factory.build(:meeting, :target => Factory.build(:group))
      m.foreign_key_valid?.should be_false
      lambda{ m.save! }.should raise_error(LISModel::InvalidForeignKeyError)
    end
  end
end