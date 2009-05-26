require File.dirname(__FILE__) + '/../spec_helper'

describe "CourseTemplate" do
  before(:each) do
    @template = Factory.build(:course_template)
  end

  describe "generated XML" do
    before(:each) do
      @xml = Hpricot(@template.to_xml).course_template
    end
    it "should contain the correct code" do
      @xml.code.should_not be_nil
      @xml.code.should == @template.code
    end
    it "should contain the correct family name" do
      @xml.title.should_not be_nil
      @xml.title.should == @template.title
    end
    it "should contain the correct description" do
      @xml.description.should_not be_nil
      @xml.description.should == @template.description
    end
    it "should contain the correct sourced_id" do
      @xml.sourced_id.should_not be_nil
      @xml.sourced_id.should == @template.sourced_id
    end
  end

  describe "generation from XML" do
    before(:each) do
      @xml = Hpricot(@template.to_xml).course_template
    end
    it "should create a saveable Template from a valid XML" do
      CourseTemplate.from_xml(@xml).save!
    end
    it "should fail without a code" do
      @xml.search('code').remove
      lambda{CourseTemplate.from_xml(@xml).save!}.should raise_error(Hpricot::MissingFieldError)
    end
    it "should fail without a title" do
      @xml.search('title').remove
      lambda{CourseTemplate.from_xml(@xml).save!}.should raise_error(Hpricot::MissingFieldError)
    end
    it "should not fail without a description" do
      @xml.search('description').remove
      lambda{CourseTemplate.from_xml(@xml).save!}.should_not raise_error(Hpricot::MissingFieldError)
    end
    it "should not generate a description tag if created with no description" do
      @xml.search('description').remove
      Hpricot(CourseTemplate.from_xml(@xml).to_xml).search('description').blank?.should == true
    end
    it "should fail without a sourced_id" do
      @xml.search('sourced_id').remove
      lambda{CourseTemplate.from_xml(@xml).save!}.should raise_error(Hpricot::MissingFieldError)
    end
  end
end