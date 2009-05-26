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
      Membership.from_xml(@xml).save!
    end
  end
end