require File.dirname(__FILE__) + '/../spec_helper'

describe "Person" do
  before(:each) do
    @person = Factory.build(:person)
  end

  describe "generated XML" do
    before(:each) do
      @xml = Hpricot(@person.to_xml).person
    end
    it "should contain the correct given name" do
      @xml.names.given.should_not be_nil
      @xml.names.given.should == @person.given_name
    end
    it "should contain the correct family name" do
      @xml.names.family.should_not be_nil
      @xml.names.family.should == @person.family_name
    end
    it "should contain the correct email" do
      @xml.contact_info.email.should_not be_nil
      @xml.contact_info.email.should == @person.email
    end
    it "should contain the correct sourced_id" do
      @xml.sourced_id.should_not be_nil
      @xml.sourced_id.should == @person.sourced_id
    end
  end

  describe "generation from XML" do
    before(:each) do
      @xml = Hpricot(@person.to_xml).person
    end
    it "should create a saveable Person from a valid XML" do
      Person.from_xml(@xml).save!
    end
    it "should fail without a given name" do
      @xml.search('given').remove
      lambda{Person.from_xml(@xml).save!}.should raise_error(Hpricot::MissingFieldError)
    end
    it "should fail without a family name" do
      @xml.search('family').remove
      lambda{Person.from_xml(@xml).save!}.should raise_error(Hpricot::MissingFieldError)
    end
    it "should fail without an email" do
      @xml.search('email').remove
      lambda{Person.from_xml(@xml).save!}.should raise_error(Hpricot::MissingFieldError)
    end
    it "should fail without a sourced_id" do
      @xml.search('sourced_id').remove
      lambda{Person.from_xml(@xml).save!}.should raise_error(Hpricot::MissingFieldError)
    end
  end
end