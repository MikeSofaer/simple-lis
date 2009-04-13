require File.dirname(__FILE__) + '/../spec_helper'

describe "CourseOffering" do
  before(:each) do
    @offering = CourseOffering.find_by_sourced_id("sample")
  end

  it "should return properly formatted XML" do
    doc = Hpricot("<course_offering>
    <sourced_id>sample</sourced_id>
    <course_template_sourced_id>sample</course_template_sourced_id>
    <term_sourced_id>200901</term_sourced_id>
    <group_sourced_id>Math</group_sourced_id>
    </course_offering>")
    out = @offering.return_xml
    Hpricot(out).to_s.should == doc.to_s
  end
end