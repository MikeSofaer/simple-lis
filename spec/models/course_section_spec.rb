require File.dirname(__FILE__) + '/../spec_helper'

describe "CourseSection" do
  before(:each) do
    @section = CourseSection.find_by_sourced_id("sample")
  end
  it "should return properly formatted XML" do
    doc = Hpricot("<course_section>
    <sourced_id>sample</sourced_id>
    <course_offering_sourced_id>sample</course_offering_sourced_id>
    <label>1</label>
    </course_section>")
    out = @section.return_xml
    Hpricot(out).to_s.should == doc.to_s
  end
end