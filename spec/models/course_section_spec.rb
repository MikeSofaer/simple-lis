require File.dirname(__FILE__) + '/../spec_helper'

describe "CourseSection" do
  before(:each) do
    @section = Factory.build(:course_section)
  end

  describe "generated XML" do
    before(:each) do
      @xml = Hpricot(@section.to_xml).course_section
    end
    
    it "should contain the correct offering_sourced_id" do
      @xml.course_offering_sourced_id.should_not be_nil
      @xml.course_offering_sourced_id.should == @section.course_offering_sourced_id
    end
    
    it "should contain the correct label" do
      @xml.label.should_not be_nil
      @xml.label.should == @section.label
    end
    
    it "should contain the correct description" do
      @xml.description.should_not be_nil
      @xml.description.should == @section.description
    end
    
    it "should contain the correct sourced_id" do
      @xml.sourced_id.should_not be_nil
      @xml.sourced_id.should == @section.sourced_id
    end
  end

  describe "generation from XML" do
    before(:each) do
      @xml = Nokogiri(@section.to_xml)
    end
    
    it "should create a saveable Section from a valid XML" do
      CourseSection.parse(@xml.to_s).save!
    end
    
    it "should fail without an offering" do
      @xml.at('course_offering_sourced_id').remove
      lambda{CourseSection.parse(@xml.to_s).save!}.should raise_error(SAXualReplication::MissingElementError)
    end
    
    it "should fail without a label" do
      @xml.at('label').remove
      lambda{CourseSection.parse(@xml.to_s).save!}.should raise_error(SAXualReplication::MissingElementError)
    end
    
    it "should not fail without a description" do
      @xml.at('description').remove
      lambda{CourseSection.parse(@xml.to_s).save!}.should_not raise_error(SAXualReplication::MissingElementError)
    end
    
    it "should not generate a description tag if created with no description" do
      Hpricot(CourseSection.parse(@xml.to_s).to_xml).search('description').blank?.should == false
      @xml.at('description').remove
      Hpricot(CourseSection.parse(@xml.to_s).to_xml).search('description').blank?.should == true
    end
    
    it "should fail without a sourced_id" do
      @xml.at('sourced_id').remove
      lambda{CourseSection.parse(@xml.to_s).save!}.should raise_error(SAXualReplication::MissingElementError)
    end
  end
end