require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe MembershipsController do
  before(:each) do
    @section1 = Factory(:course_section)
    @section2 = Factory(:course_section, :course_offering => CourseOffering.datamapper_class.all(:sourced_id => @section1.course_offering_sourced_id))
    @person1 = Factory(:person)
    @person2 = Factory(:person)
    @m1 = Factory(:membership, :target => @section1, :person => @person1)
    @m2 = Factory(:membership, :target => @section2, :person => @person2)
  end
  it "should give all section memberships" do
    get(:index)
    ids = Hpricot(response.body).search('sourced_id').map(&:inner_text)
    ids.member?(@m1.sourced_id).should be_true
    ids.member?(@m2.sourced_id).should be_true
  end
  it "should give only a user's memberships" do
    get(:index, :person_sourced_id => @person1.sourced_id)
    ids = Hpricot(response.body).search('sourced_id').map(&:inner_text)
    ids.member?(@m1.sourced_id).should be_true
    ids.member?(@m2.sourced_id).should be_false
  end
end
