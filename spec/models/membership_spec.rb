require File.dirname(__FILE__) + '/../spec_helper'

describe "Membership" do
  before(:each) do
    @membership = Factory.build(:membership)
  end

  describe "generation from XML" do
    before(:each) do
      @xml = Hpricot(@membership.to_xml).membership
    end

    it "should create a saveable Membership from a valid XML" do
      Membership.parse(@xml.to_s).save!
    end
  end
  
  context "foreign_key_valid? tests" do
    before(:each) do
      @user = Factory(:person)
      @org = Factory(:group)
    end
    
    it "should be true with valid user and target" do
      m = Factory.build(:membership, :target => @org, :person => @user)
      m.foreign_key_valid?.should be_true
      lambda{ m.save! }.should_not raise_error
    end
    
    it "should be true without valid user but should get mysqlerror about foreign key constraints" do
      m = Factory.build(:membership, :target => @org, :person => Factory.build(:person))
      m.foreign_key_valid?.should be_true
      lambda{ m.save! }.should raise_error
    end
    
    it "should be false without valid target org" do
      m = Factory.build(:membership, :target => Factory.build(:group), :person => @user)
      m.foreign_key_valid?.should be_false
      lambda{ m.save! }.should raise_error(LISModel::InvalidForeignKeyError)
    end
  end
end