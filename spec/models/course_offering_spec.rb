require File.dirname(__FILE__) + '/../spec_helper'

describe "CourseOffering" do
  before(:each) do
    @offering = Factory.build(:course_offering)
  end

  describe "generated XML" do
    before(:each) do
      @xml = Hpricot(@offering.to_xml).course_offering
    end
    it "should contain the correct template_sourced_id" do
      @xml.course_template_sourced_id.should_not be_nil
      @xml.course_template_sourced_id.should == @offering.course_template_sourced_id
    end
    it "should contain the correct term" do
      @xml.term_sourced_id.should_not be_nil
      @xml.term_sourced_id.should == @offering.term_sourced_id
    end
    it "should contain the correct group" do
      @xml.group_sourced_id.should_not be_nil
      @xml.group_sourced_id.should == @offering.group_sourced_id
    end
    it "should contain the correct sourced_id" do
      @xml.sourced_id.should_not be_nil
      @xml.sourced_id.should == @offering.sourced_id
    end
  end

  describe "generation from XML" do
    before(:each) do
      @xml = Hpricot(@offering.to_xml).course_offering
    end
    it "should create a saveable Template from a valid XML" do
      CourseOffering.from_xml(@xml).save!
    end
    it "should fail without a template" do
      @xml.search('course_template_sourced_id').remove
      lambda{CourseOffering.from_xml(@xml).save!}.should raise_error(Hpricot::MissingFieldError)
    end
    it "should fail without a term" do
      @xml.search('term_sourced_id').remove
      lambda{CourseOffering.from_xml(@xml).save!}.should raise_error(Hpricot::MissingFieldError)
    end
    it "should not fail without a group" do
      @xml.search('group_sourced_id').remove
      lambda{CourseOffering.from_xml(@xml).save!}.should_not raise_error(Hpricot::MissingFieldError)
    end
    it "should fail without a sourced_id" do
      @xml.search('sourced_id').remove
      lambda{CourseOffering.from_xml(@xml).save!}.should raise_error(Hpricot::MissingFieldError)
    end
  end
end