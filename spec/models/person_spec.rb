require File.dirname(__FILE__) + '/../spec_helper'

describe "Person" do
  before(:each) do
    @person = Factory.build(:person)
  end

  describe "generated XML" do
    before(:each) do
      @xml = Nokogiri(@person.to_xml)
    end
    it "should contain the correct given name" do
      @xml.given.should_not be_nil
      @xml.given.should == @person.given_name
    end
    it "should contain the correct family name" do
      @xml.family.should_not be_nil
      @xml.family.should == @person.family_name
    end
    it "should contain the correct email" do
      @xml.email.should_not be_nil
      @xml.email.should == @person.email
    end
    it "should contain the correct sourced_id" do
      @xml.sourced_id.should_not be_nil
      @xml.sourced_id.should == @person.sourced_id
    end
  end

  describe "generation from XML" do
    before(:each) do
      @xml = '<people>' + @person.to_xml + '</people>'
    end
    it "should create a saveable Person from a valid XML" do
      People.parse(@xml).save!
    end
    describe 'failure states' do
      before(:each) do
        @xml = Nokogiri(@xml)
      end
      it "should fail without a given name" do
        @xml.at('given').remove
        people = People.parse(@xml.to_s)
        lambda{people.save!}.should raise_error(ActiveRecord::StatementInvalid)
      end
      it "should fail without a family name" do
        @xml.at('family').remove
        lambda{People.parse(@xml.to_s).save!}.should raise_error(ActiveRecord::StatementInvalid)
      end
      it "should fail without an email" do
        @xml.at('email').remove
        lambda{People.parse(@xml.to_s).save!}.should raise_error(ActiveRecord::StatementInvalid)
      end
      it "should fail without a sourced_id" do
        @xml.at('sourced_id').remove
        lambda{People.parse(@xml.to_s).save!}.should raise_error(ActiveRecord::StatementInvalid)
      end
    end
  end
end