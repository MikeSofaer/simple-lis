require File.dirname(__FILE__) + '/../spec_helper'

describe "Group" do
  before(:each) do
    @group = Factory.build(:school)
  end

  describe "generated XML" do
    before(:each) do
      @xml = Hpricot(@group.to_xml).group
    end
    it "should contain the correct title" do
      @xml.title.should_not be_nil
      @xml.title.should == @group.title
    end
    it "should contain the correct category" do
      @xml.category.should_not be_nil
      @xml.category.should == @group.category
    end
    it "should contain the correct sub-category" do
      @xml.sub_category.should_not be_nil
      @xml.sub_category.should == @group.sub_category
    end
    it "should contain the correct description" do
      @xml.description.should_not be_nil
      @xml.description.should == @group.description
    end
    it "should contain the correct parent_sourced_id" do
      @xml.parent_sourced_id.should_not be_nil
      @xml.parent_sourced_id.should == @group.parent_sourced_id
    end
    it "should contain the correct sourced_id" do
      @xml.sourced_id.should_not be_nil
      @xml.sourced_id.should == @group.sourced_id
    end
  end

  describe "generation from XML" do
    before(:each) do
      @xml = Hpricot(@group.to_xml).group
    end
    it "should create a saveable Template from a valid XML" do
      Group.parse(@xml.to_s).save!
    end
    it "should fail without a title" do
      @xml.search('title').remove
      lambda{Group.parse(@xml.to_s).save!}.should raise_error(SAXualReplication::MissingElementError)
    end
    it "should fail without a category" do
      @xml.search('category').remove
      lambda{Group.parse(@xml.to_s).save!}.should raise_error(SAXualReplication::MissingElementError)
    end
    it "should fail without a sub-category" do
      @xml.search('sub_category').remove
      lambda{Group.parse(@xml.to_s).save!}.should raise_error(SAXualReplication::MissingElementError)
    end
    it "should not fail without a description" do
      @xml.search('description').remove
      lambda{Group.parse(@xml.to_s).save!}.should_not raise_error(SAXualReplication::MissingElementError)
    end
    it "should not generate a description tag if created with no description" do
      Hpricot(Group.parse(@xml.to_s).to_xml).search('description').blank?.should == false
      @xml.search('description').remove
      Hpricot(Group.parse(@xml.to_s).to_xml).search('description').blank?.should == true
    end
    it "should not fail without a parent" do
      @xml.search('parent_sourced_id').remove
      lambda{Group.parse(@xml.to_s).save!}.should_not raise_error(SAXualReplication::MissingElementError)
    end
    it "should not generate a parent tag if created with no parent" do
      Hpricot(Group.parse(@xml.to_s).to_xml).search('parent_sourced_id').blank?.should == false
      @xml.search('parent_sourced_id').remove
      Hpricot(Group.parse(@xml.to_s).to_xml).search('parent_sourced_id').blank?.should == true
    end
    it "should fail without a sourced_id" do
      @xml.search('sourced_id').remove
      lambda{Group.parse(@xml.to_s).save!}.should raise_error(SAXualReplication::MissingElementError)
    end
  end
end