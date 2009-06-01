require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe CourseOfferingsController do
  before(:each) do
    @offering = Factory(:course_offering)
  end
  it "should return a URL to an offering" do
    get(:index)
    Hpricot(response.body).search('sourced_id').inner_text.should == @offering.sourced_id
  end
  it "should allow you to retrieve the offering" do
    get(:index, :sourced_id => @offering.sourced_id)
    Hpricot(response.body).search('sourced_id').inner_text.should == @offering.sourced_id
  end
  it "should allow you to delete the offering" do
    go = lambda{delete(:delete, :sourced_id => @offering.sourced_id)}  
    go.should change(CourseOffering, :count).by(-1)
    response.status.should == "204 NO CONTENT"
  end
it "should not allow you to delete the offering if there is a section" do
    Factory(:course_section, :course_offering => @offering)
    go = lambda{delete(:delete, :sourced_id => @offering.sourced_id)}
    go.should change(CourseOffering, :count).by(0)
    response.body.should == "hate"
    response.status.should == "422 NO CONTENT"
  end
end
